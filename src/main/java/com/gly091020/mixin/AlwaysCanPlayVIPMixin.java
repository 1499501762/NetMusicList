package com.gly091020.mixin;

import com.github.tartaricacid.netmusic.item.ItemMusicCD;
import net.fabricmc.loader.api.FabricLoader;
import net.minecraft.item.ItemStack;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(ItemMusicCD.class)
public class AlwaysCanPlayVIPMixin {
    @Inject(method = "getSongInfo", at = @At("RETURN"), cancellable = true)
    private static void stripVip(ItemStack stack, CallbackInfoReturnable<ItemMusicCD.SongInfo> cir) {
        ItemMusicCD.SongInfo info = cir.getReturnValue();
        boolean hasLoginNeedMod = FabricLoader.getInstance().isModLoaded("net_music_login_need");
        if (hasLoginNeedMod && info != null && info.vip) {
            // 登录依赖模组已安装时，去掉 VIP 标记以允许播放
            info.vip = false;
            cir.setReturnValue(info);
        }
    }
}
