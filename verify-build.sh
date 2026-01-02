#!/bin/bash

echo "=== NetMusicList Build Verification ==="
echo ""

# Check if gradle wrapper exists
if [ ! -f ./gradlew ]; then
    echo "❌ gradlew not found"
    exit 1
fi

echo "✅ gradlew found"
echo ""

# Build with verbose output
echo "Building project..."
./gradlew clean build --stacktrace --info 2>&1 | tail -50

echo ""
echo "=== Checking build output ==="
echo ""

if [ ! -d "build/libs" ]; then
    echo "❌ build/libs directory not found"
    exit 1
fi

echo "📁 build/libs contents:"
ls -lh build/libs/

echo ""
echo "=== JAR File Analysis ==="

for jar in build/libs/*.jar; do
    if [ -f "$jar" ]; then
        echo ""
        echo "File: $(basename $jar)"
        echo "Size: $(du -h "$jar" | cut -f1)"
        echo "Entry count: $(jar tf "$jar" | wc -l)"
        echo ""
        echo "First 20 entries:"
        jar tf "$jar" | head -20
        echo ""
        echo "Checking for class files:"
        if jar tf "$jar" | grep -q "\.class$"; then
            echo "✅ Class files found"
            jar tf "$jar" | grep "\.class$" | head -10
        else
            echo "❌ No class files found!"
        fi
    fi
done

echo ""
echo "=== Build Directory Structure ==="
find build -type f -name "*.jar" -o -name "*.class" | head -20
