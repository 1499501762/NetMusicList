package com.gly091020.client;

import com.gly091020.NetMusicListConfig;
import com.gly091020.PlayMode;
import com.terraformersmc.modmenu.api.ConfigScreenFactory;
import com.terraformersmc.modmenu.api.ModMenuApi;
import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.minecraft.client.gui.DrawContext;
import net.minecraft.client.gui.screen.Screen;
import net.minecraft.client.gui.widget.ButtonWidget;
import net.minecraft.client.gui.widget.CyclingButtonWidget;
import net.minecraft.text.Text;

@Environment(EnvType.CLIENT)
public class ModMenuIntegration implements ModMenuApi {
    @Override
    public ConfigScreenFactory<?> getModConfigScreenFactory() {
        return ConfigScreen::new;
    }

    private static class ConfigScreen extends Screen {
        private final Screen parent;
        private PlayMode defaultPlayMode;
        private boolean autoNextEnabled;
        private boolean showPlayModeTooltip;

        protected ConfigScreen(Screen parent) {
            super(Text.translatable("config.net_music_list.title"));
            this.parent = parent;
            var cfg = NetMusicListConfig.get();
            this.defaultPlayMode = cfg.defaultPlayMode;
            this.autoNextEnabled = cfg.autoNextEnabled;
            this.showPlayModeTooltip = cfg.showPlayModeTooltip;
        }

        @Override
        protected void init() {
            int centerX = this.width / 2;
            int y = this.height / 2 - 40;

            this.addDrawableChild(CyclingButtonWidget.builder(PlayMode::getName)
                    .values(PlayMode.values())
                    .initially(defaultPlayMode)
                    .build(centerX - 110, y, 220, 20, Text.translatable("config.net_music_list.default_play_mode"),
                            (button, value) -> defaultPlayMode = value));

            y += 24;
            this.addDrawableChild(CyclingButtonWidget.onOffBuilder(autoNextEnabled)
                    .build(centerX - 110, y, 220, 20, Text.translatable("config.net_music_list.auto_next"),
                            (button, value) -> autoNextEnabled = value));

            y += 24;
            this.addDrawableChild(CyclingButtonWidget.onOffBuilder(showPlayModeTooltip)
                    .build(centerX - 110, y, 220, 20, Text.translatable("config.net_music_list.show_tooltip"),
                            (button, value) -> showPlayModeTooltip = value));

            y += 32;
            this.addDrawableChild(ButtonWidget.builder(Text.translatable("gui.done"), button -> saveAndClose())
                    .dimensions(centerX - 110, y, 100, 20)
                    .build());
            this.addDrawableChild(ButtonWidget.builder(Text.translatable("gui.cancel"), button -> this.close())
                    .dimensions(centerX + 10, y, 100, 20)
                    .build());
        }

        @Override
        public void render(DrawContext context, int mouseX, int mouseY, float delta) {
            // 使用纯色背景，避免默认模糊
            context.fill(0, 0, this.width, this.height, 0xC0000000);
            
            // 调用父类渲染按钮，但我们已经在上面画了背景
            super.render(context, mouseX, mouseY, delta);
            
            // 最后绘制标题，确保在最上层
            context.drawCenteredTextWithShadow(this.textRenderer, this.title, this.width / 2, this.height / 2 - 68, 0xFFFFFF);
        }
        
        @Override
        public void renderBackground(DrawContext context, int mouseX, int mouseY, float delta) {
            // 禁用默认背景渲染（包括模糊效果）
        }

        private void saveAndClose() {
            var cfg = NetMusicListConfig.get();
            cfg.defaultPlayMode = this.defaultPlayMode;
            cfg.autoNextEnabled = this.autoNextEnabled;
            cfg.showPlayModeTooltip = this.showPlayModeTooltip;
            cfg.save();
            this.close();
        }

        @Override
        public void close() {
            this.client.setScreen(this.parent);
        }
    }
}
