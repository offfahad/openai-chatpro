import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_ai_chatgpt/constants/api_constants.dart';
class ApiService {

  // send message and get answers
  static Future<String> sendMessageToChatGPT({
    required String message,
    required String modelId,
    required bool isText,
  }) async {
    if(isText){
      // generate a text response
      try{
        var response = await http.post(
            Uri.parse('$baseUrl/chat/completions'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $chatGPTApiKey"
          },
          body: jsonEncode(
            {
              "model": modelId,
              "messages": [
                {"role": "user",
                  "content": message}]
            }
          )
        );

        Map jsonResponse = jsonDecode(response.body);

        if(jsonResponse['error'] != null) {
          throw HttpException(jsonResponse['error']['message']);
        }

        String answer = '';
        if(jsonResponse['choices'].length > 0) {
          print('ANSWER : ${jsonResponse['choices'][0]['message']['content']}');

          answer = jsonResponse['choices'][0]['message']['content'];
        }

        return answer;

      } catch (error){
        print(error);
        rethrow;
      }
    } else {
      // generate an image response
      try{

        var response = await http.post(
            Uri.parse('$baseUrl/images/generations'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $chatGPTApiKey"
            },
            body: jsonEncode(
                {
                  "prompt": message,
                  "n": 2,
                  "size": "1024x1024"
                }
            )
        );

        Map jsonResponse = jsonDecode(response.body);

        if(jsonResponse['error'] != null) {
          throw HttpException(jsonResponse['error']['message']);
        }

        String imageUrl = '';
        if(jsonResponse['data'].length > 0) {
          print('ANSWER : ${jsonResponse['data'][0]['url']}');

          imageUrl = jsonResponse['data'][0]['url'];
        }

        return imageUrl;

      } catch (error){
        print(error);
        rethrow;
      }
    }
  }

  // get audio bytes
  static Future<Uint8List> fetchAudioBytes({
    required String text,
    required String voiceId,
  }) async {
      try{
        var response = await http.post(
            Uri.parse('$elevenLabsBaseUrl/$voiceId'),
            headers: {
              "Content-Type": "application/json",
              "xi-api-key": elevenLabsApiKey
            },
            body: jsonEncode(
                {
                  "key": elevenLabsApiKey,
                  "text": text,
                  "voice_settings": {
                    "stability": 0,
                    "similarity_boost": 0
                  },
                  'h1':'en-us',
                  'c':'WAV',
                  'f':'44hz_16bit_stereo'
                }
            ),
        );

        if(response.statusCode == 200) {
          final bytes = response.bodyBytes;
          return bytes;
        } else {
          throw Expando('Failed to load audio');
        }

      } catch (error){
        print(error);
        rethrow;
      }

  }
}