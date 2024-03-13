import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/configs/config.dart';
import '../../core/failure/failure.dart';
import '../../core/utils/typedefs.dart';
import '../../presentation/pages/setting_update/models/update_data.dart';

class _UseCase {
  FutureUseCase<UpdateData?> call() async {
    try {
      final response = await http.post(
        Uri.parse('${Config.detaBaseUrl}/cashflow/query'),
        headers: {
          'X-API-Key': Config.detaApiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final data = jsonDecode(body)['items'] as List<dynamic>;
        final latestBuildNumber = data
            .where((element) {
              return element['key'] == 'build_number';
            })
            .map((e) => e['value'])
            .first;
        final downloadUrl = data
            .where((element) => element['key'] == 'download_url')
            .map((e) => e['value'])
            .first;

        final packageInfo = await PackageInfo.fromPlatform();
        final currentBuildNumber =
            int.parse(packageInfo.buildNumber) + (kDebugMode ? 2000 : 0);

        if (currentBuildNumber < latestBuildNumber) {
          // new update available
          return Right(UpdateData(
            downloadUrl: downloadUrl,
          ));
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(
        e is Failure ? e : Failure(message: e.toString()),
      );
    }
  }
}

// provider
final checkUpdateUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase();
});
