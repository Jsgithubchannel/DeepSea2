// lib/services/identification_service.dart
import 'dart:typed_data';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/services.dart' show rootBundle; // rootBundle 사용을 위해 추가
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class IdentificationService {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isModelLoaded = false;
  final String _modelName = 'jellyfish_identifier';
  static const int IMG_SIZE = 224;

  bool get isModelLoaded => _isModelLoaded;

  // 모델 및 레이블 로드 (앱 시작 시 호출 권장)
  Future<void> loadModel() async {
    if (_isModelLoaded) return;

    try {
      // 1. Firebase에서 모델 다운로드
      print('Downloading model...');
      final customModel = await FirebaseModelDownloader.instance.getModel(
        _modelName,
        FirebaseModelDownloadType.localModelUpdateInBackground,
        FirebaseModelDownloadConditions(),
      );
      final modelFile = customModel.file;
      print('Model downloaded to: ${modelFile.path}');

      // 2. tflite 인터프리터 로드
      print('Loading interpreter...');
      _interpreter = await Interpreter.fromFile(modelFile);
      // _interpreter.allocateTensors(); // 필요시 텐서 할당

      // 3. 레이블 파일 로드 (assets/labels.txt)
      print('Loading labels...');
      _labels = await _loadLabels('assets/labels.txt');

      _isModelLoaded = true;
      print('Model and labels loaded successfully.');
      print(
        'Input details: ${_interpreter?.getInputTensor(0).shape} ${_interpreter?.getInputTensor(0).type}',
      );
      print(
        'Output details: ${_interpreter?.getOutputTensor(0).shape} ${_interpreter?.getOutputTensor(0).type}',
      );
    } catch (e) {
      print('Error loading model: $e');
      _isModelLoaded = false;
    }
  }

  // 레이블 파일 로드 함수
  Future<List<String>> _loadLabels(String assetPath) async {
    try {
      final labelString = await rootBundle.loadString(assetPath);
      // 개행 문자로 분리하고 빈 줄 제거
      return labelString
          .split('\n')
          .map((label) => label.trim()) // 앞뒤 공백 제거
          .where((label) => label.isNotEmpty) // 빈 줄 필터링
          .toList();
    } catch (e) {
      print("Error loading labels: $e");
      return [];
    }
  }

  // 이미지 식별 함수
  Future<Map<String, double>?> identifyJellyfish(String imagePath) async {
    if (!_isModelLoaded ||
        _interpreter == null ||
        _labels == null ||
        _labels!.isEmpty) {
      print('Model or labels not loaded properly.');
      return null;
    }

    try {
      // 1. 이미지 로드 및 전처리
      print('Preprocessing image: $imagePath');
      final inputTensor = await _preprocessImage(imagePath);
      if (inputTensor == null) {
        print('Image preprocessing failed.');
        return null;
      }
      print('Image preprocessing done.');

      // 2. 출력 텐서 준비
      final outputShape = _interpreter!.getOutputTensor(0).shape; // 예: [1, 6]
      final TensorType outputType = _interpreter!.getOutputTensor(0).type;
      dynamic outputTensor; // dynamic으로 선언하여 타입에 맞게 할당

      // 타입에 따라 출력 버퍼 생성
      if (outputType == TensorType.float32) {
        outputTensor = List.generate(
          outputShape[0],
          (_) => List.filled(outputShape[1], 0.0),
        );
      } else if (outputType == TensorType.uint8) {
        outputTensor = List.generate(
          outputShape[0],
          (_) => List.filled(outputShape[1], 0),
        );
      } else {
        print('Unsupported output type: $outputType');
        return null;
      }

      // 3. 모델 추론 실행
      print('Running inference...');
      _interpreter!.run(inputTensor, outputTensor);
      print('Inference completed.');

      // 4. 결과 후처리
      List<num> results; // num 타입으로 변경하여 float/int 모두 처리
      if (outputTensor[0] is List<double>) {
        results = outputTensor[0] as List<double>;
      } else if (outputTensor[0] is List<int>) {
        results = outputTensor[0] as List<int>;
      } else {
        print('Unexpected output tensor type.');
        return null;
      }

      Map<String, double> labeledProbabilities = {};
      for (int i = 0; i < results.length; i++) {
        if (i < _labels!.length) {
          // 확률 값 정규화 (Uint8 모델의 경우 0~255 값을 0~1로 변환)
          double probability =
              (outputType == TensorType.uint8)
                  ? results[i].toDouble() / 255.0
                  : results[i].toDouble();
          labeledProbabilities[_labels![i]] = probability;
        } else {
          print(
            "Warning: Output index $i out of bounds for labels list (size: ${_labels!.length})",
          );
        }
      }

      // 확률 순으로 정렬 (가장 높은 확률이 먼저 오도록)
      var sortedEntries =
          labeledProbabilities.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedEntries.isNotEmpty) {
        print(
          "Top Identification Result: ${sortedEntries.first.key} (${sortedEntries.first.value.toStringAsFixed(3)})",
        );
        return {
          sortedEntries.first.key: sortedEntries.first.value,
        }; // 가장 높은 확률의 결과 반환
      } else {
        print("No valid results after processing.");
        return {};
      }
    } catch (e) {
      print('Error during inference: $e');
      return null;
    }
  }

  // 이미지 전처리 함수
  Future<Uint8List?> _preprocessImage(String imagePath) async {
    if (_interpreter == null) {
      print("Interpreter is not loaded.");
      return null;
    }
    try {
      print("Loading asset: $imagePath");

      // 1. rootBundle을 사용하여 에셋 로드
      final ByteData data = await rootBundle.load(imagePath);
      // 2. ByteData를 Uint8List로 변환
      final Uint8List imageBytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      // 3. Uint8List를 image 패키지의 Image 객체로 디코딩
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        print("Failed to decode image from asset bytes");
        return null;
      }

      final inputDetails = _interpreter!.getInputTensor(0);
      final inputHeight = IMG_SIZE;
      final inputWidth = IMG_SIZE;
      final TensorType inputType = inputDetails.type;

      print('Model Input Type from Interpreter: $inputType');
      print('Resizing image to ${inputWidth}x$inputHeight');

      img.Image resizedImage = img.copyResize(
        image,
        width: inputWidth,
        height: inputHeight,
      );

      if (inputType == TensorType.float32) {
        var buffer = Float32List(1 * inputHeight * inputWidth * 3);
        int pixelIndex = 0;
        for (var y = 0; y < inputHeight; y++) {
          for (var x = 0; x < inputWidth; x++) {
            // getPixel은 Pixel 객체를 반환할 수 있음
            var pixel = resizedImage.getPixel(x, y);
            // Pixel 객체의 r, g, b 속성 사용
            buffer[pixelIndex++] = pixel.r / 255.0; // 0~1 정규화 예시
            buffer[pixelIndex++] = pixel.g / 255.0;
            buffer[pixelIndex++] = pixel.b / 255.0;
          }
        }
        print(
          'Image processed as Float32 (0-1 range). Buffer size: ${buffer.length}',
        );
        return buffer.buffer.asUint8List();
      } else if (inputType == TensorType.uint8) {
        var buffer = Uint8List(1 * inputHeight * inputWidth * 3);
        int pixelIndex = 0;
        for (var y = 0; y < inputHeight; y++) {
          for (var x = 0; x < inputWidth; x++) {
            // getPixel은 Pixel 객체를 반환할 수 있음
            var pixel = resizedImage.getPixel(x, y);
            // Pixel 객체의 r, g, b 속성 사용
            buffer[pixelIndex++] = pixel.r.toInt(); // Uint8이므로 정수로 변환
            buffer[pixelIndex++] = pixel.g.toInt();
            buffer[pixelIndex++] = pixel.b.toInt();
          }
        }
        print(
          'Image processed as Uint8 (0-255 range). Buffer size: ${buffer.length}',
        );
        return buffer;
      } else {
        print("Unsupported input type from model: $inputType");
        return null;
      }
    } catch (e) {
      print("Error preprocessing image asset ($imagePath): $e");
      return null;
    }
  }

  // 리소스 해제 (앱 종료 시 호출 권장)
  void close() {
    _interpreter?.close();
    _isModelLoaded = false;
    print('IdentificationService closed.');
  }
}
