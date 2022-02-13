untyped
global function Whisper_AddCallback

ClServer_MessageStruct function handleChat(ClServer_MessageStruct message) {
    print("Message Received: " + message.message)

    if (message.message.find("/whisper ") != 0) {
        return message
    }

    message.shouldBlock = true

    var whisperParams = message.message.slice(9)
    var separator = whisperParams.find(" ")

    if (separator == null) {
        NSChatWhisperText(message.player.GetPlayerIndex(), "Usage: /whisper [player] [message]")
        return message
    }

    var toName = whisperParams.slice(0, separator)
    var whisperMsg = whisperParams.slice(separator + 1)

    array<entity> allPlayers = GetPlayerArray()
    entity toPlayer = null
    foreach ( entity player in allPlayers ) {
        if (player.GetPlayerName() == toName) {
            toPlayer = player
            break
        }
    }

    if (toPlayer == null) {
        NSChatWhisperText(message.player.GetPlayerIndex(), "There are no players called " + toName + ".")
        return message
    }

    NSChatWhisperText(toPlayer.GetPlayerIndex(), "\x1b[95m[WHISPER]" + message.player.GetPlayerName() + ": \x1b[0m" + whisperMsg)

    return message
}

void function Whisper_AddCallback() {
    AddCallback_OnReceivedSayTextMessage(handleChat)
}
