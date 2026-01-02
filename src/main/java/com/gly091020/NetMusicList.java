package com.gly091020;

import com.github.tartaricacid.netmusic.init.InitItems;
import com.gly091020.network.SendDataPayload;
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.itemgroup.v1.ItemGroupEvents;
import net.fabricmc.fabric.api.networking.v1.PayloadTypeRegistry;
import net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.registry.Registries;
import net.minecraft.registry.Registry;
import net.minecraft.registry.RegistryKey;
import net.minecraft.registry.RegistryKeys;
import net.minecraft.util.Identifier;

public class NetMusicList implements ModInitializer {
    public static final String ModID = "net_music_list";
    public static final NetMusicListItem MUSIC_LIST_ITEM = new NetMusicListItem(new Item.Settings().maxCount(1));
    @Override
    public void onInitialize() {
        NetMusicListConfig.get();
        Registry.register(Registries.ITEM, Identifier.of(ModID, "music_list"), MUSIC_LIST_ITEM);
        PayloadTypeRegistry.playC2S().register(SendDataPayload.ID, SendDataPayload.CODEC);
        ServerPlayNetworking.registerGlobalReceiver(SendDataPayload.ID, (payload, context) -> {
            context.server().execute(() -> {
                var player = context.player();
                var stack = player.getMainHandStack();
                if (stack.isOf(MUSIC_LIST_ITEM)) {
                    NetMusicListItem.setSongIndex(stack, payload.index());
                    NetMusicListItem.setPlayMode(stack, PlayMode.getMode(payload.playModeOrdinal()));
                }
            });
        });
        ItemGroupEvents.modifyEntriesEvent(RegistryKey.of(RegistryKeys.ITEM_GROUP,
                Identifier.of("netmusic", "netmusic_group"))).register(fabricItemGroupEntries ->
                fabricItemGroupEntries.addAfter(new ItemStack(InitItems.MUSIC_CD),
                        new ItemStack(MUSIC_LIST_ITEM)));
    }
}
