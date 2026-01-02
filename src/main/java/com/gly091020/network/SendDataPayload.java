package com.gly091020.network;

import net.minecraft.network.RegistryByteBuf;
import net.minecraft.network.codec.PacketCodec;
import net.minecraft.network.packet.CustomPayload;
import net.minecraft.util.Identifier;

public record SendDataPayload(int index, int playModeOrdinal) implements CustomPayload {
    public static final CustomPayload.Id<SendDataPayload> ID = new CustomPayload.Id<>(Identifier.of("net_music_list", "send_data"));
    public static final PacketCodec<RegistryByteBuf, SendDataPayload> CODEC = PacketCodec.of(SendDataPayload::write, SendDataPayload::read);

    private static SendDataPayload read(RegistryByteBuf buf) {
        int idx = buf.readVarInt();
        int mode = buf.readVarInt();
        return new SendDataPayload(idx, mode);
    }

    private static void write(SendDataPayload payload, RegistryByteBuf buf) {
        buf.writeVarInt(payload.index());
        buf.writeVarInt(payload.playModeOrdinal());
    }

    @Override
    public CustomPayload.Id<? extends CustomPayload> getId() {
        return ID;
    }
}
