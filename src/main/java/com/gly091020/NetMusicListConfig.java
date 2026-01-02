package com.gly091020;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import net.fabricmc.loader.api.FabricLoader;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;

public class NetMusicListConfig {
    private static final Gson GSON = new GsonBuilder().setPrettyPrinting().create();
    private static final Path CONFIG_PATH = FabricLoader.getInstance().getConfigDir().resolve("net_music_list.json");

    public PlayMode defaultPlayMode = PlayMode.LOOP;
    public boolean autoNextEnabled = true;
    public boolean showPlayModeTooltip = true;

    private static NetMusicListConfig INSTANCE;

    public static NetMusicListConfig get() {
        if (INSTANCE == null) {
            INSTANCE = loadInternal();
        }
        return INSTANCE;
    }

    public void save() {
        try {
            Files.createDirectories(CONFIG_PATH.getParent());
            try (Writer writer = Files.newBufferedWriter(CONFIG_PATH)) {
                GSON.toJson(this, writer);
            }
        } catch (IOException e) {
            // Failing to save config should not crash the game; log to stdout for diagnosis.
            System.err.println("[NetMusicList] Failed to save config: " + e.getMessage());
        }
    }

    private static NetMusicListConfig loadInternal() {
        if (Files.exists(CONFIG_PATH)) {
            try (Reader reader = Files.newBufferedReader(CONFIG_PATH)) {
                NetMusicListConfig cfg = GSON.fromJson(reader, NetMusicListConfig.class);
                if (cfg != null) {
                    return cfg;
                }
            } catch (IOException e) {
                System.err.println("[NetMusicList] Failed to read config, using defaults: " + e.getMessage());
            }
        }
        NetMusicListConfig defaults = new NetMusicListConfig();
        defaults.save();
        return defaults;
    }
}
