class AgoraStub {
  static Future<void> joinChannel({
    required String channelName,
    required String uid,
  }) async {
    print('Stub: joining channel $channelName as $uid');
  }

  static Future<void> leaveChannel() async {
    print('Stub: leaving channel');
  }

  static void muteLocalAudio(bool muted) {
    print('Stub: mute = $muted');
  }
}
