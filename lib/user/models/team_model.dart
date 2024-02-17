import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/qr_converter_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import 'package:scouting_app_2024/shared.dart';

enum TeamAlliance {
  blue(0xFF2463B0),
  red(0xFFE92A2f);

  final int color;

  const TeamAlliance(this.color);

  Color toColor() => Color(color);
}

enum MatchType { practice, qualification, playoff }

enum MatchStartingPosition { left, middle, right }

enum EndStatus { parked, onstage, failed }

enum AutoPickup { l, m, r, no }

enum Harmony { yes, no, failed }

enum TrapScored { yes, no, missed }

enum MicScored { yes, no, missed }

class HollisticMatchScoutingData
    extends QRCompatibleData<HollisticMatchScoutingData>
    with QRCompressedCompatibleDataBlob<HollisticMatchScoutingData> {
  PrelimInfo preliminary;
  AutoInfo auto;
  TeleOpInfo teleop;
  EndgameInfo endgame;
  MiscInfo misc;
  late String id;

  HollisticMatchScoutingData({
    required this.preliminary,
    required this.misc,
    required this.auto,
    required this.teleop,
    required this.endgame,
  }) {
    id = Shared.uuid.v1();
  }

  @override
  String toString() {
    return "ID: $id Preliminary: ${preliminary.exportMap().toString()}\nAuto: ${auto.exportMap().toString()}\nTeleop: ${teleop.exportMap().toString()}\nEndgame: ${endgame.exportMap().toString()}";
  }

  static HollisticMatchScoutingData fromCompatibleFormat(
      String rawData) {
    Debug().info("Decoding the hollistic match data... $rawData");
    final Map<dynamic, dynamic> data =
        jsonDecode(rawData) as Map<dynamic, dynamic>;
    final Map<dynamic, dynamic> innerData =
        jsonDecode(data["data"].toString()) as Map<dynamic, dynamic>;
    return HollisticMatchScoutingData(
      preliminary: PrelimInfo.fromCompatibleFormat(
          innerData["preliminary"].toString()),
      auto:
          AutoInfo.fromCompatibleFormat(innerData["auto"].toString()),
      teleop: TeleOpInfo.fromCompatibleFormat(
          innerData["teleop"].toString()),
      endgame: EndgameInfo.fromCompatibleFormat(
          innerData["endgame"].toString()),
      misc:
          MiscInfo.fromCompatibleFormat(innerData["misc"].toString()),
    );
  }

  static HollisticMatchScoutingData fromCompressedCompatibleFormat(
      List<int> compressedData) {
    return HollisticMatchScoutingData.fromCompatibleFormat(
        utf8.decode(gzip.decode(compressedData)));
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<dynamic, dynamic>{
      "\"id\"": id,
      "\"data\"": <dynamic, dynamic>{
        "\"preliminary\"": preliminary.toCompatibleFormat(),
        "\"auto\"": auto.toCompatibleFormat(),
        "\"teleop\"": teleop.toCompatibleFormat(),
        "\"endgame\"": endgame.toCompatibleFormat(),
        "\"misc\"": misc.toCompatibleFormat()
      }
    });
  }
}
