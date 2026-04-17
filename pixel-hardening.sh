#!/bin/bash

# Define the list of packages to disable
PACKAGES=(
  "com.google.android.googlequicksearchbox"
  "com.google.android.apps.googleassistant"
  "com.google.android.apps.assistant"
  "com.google.android.gm"
  "com.google.android.apps.messaging"
  "com.google.android.apps.tachyon"
  "com.google.android.apps.dynamite"
  "com.google.android.apps.maps"
  "com.google.android.youtube"
  "com.google.android.apps.youtube.music"
  "com.google.android.apps.photos"
  "com.google.android.videos"
  "com.google.android.apps.docs"
  "com.google.android.apps.docs.editors.docs"
  "com.google.android.apps.docs.editors.sheets"
  "com.google.android.apps.docs.editors.slides"
  "com.google.android.keep"
  "com.google.android.calendar"
  "com.google.android.contacts"
  "com.google.android.apps.tasks"
  "com.google.android.apps.healthdata"
  "com.google.android.apps.fitness"
  "com.google.android.apps.wellbeing"
  "com.google.android.as"
  "com.google.android.as.oss"
  "com.google.android.aicore"
  "com.google.android.dialer"
  "com.google.android.apps.restore"
  "com.google.android.apps.pixelmigrate"
  "com.google.android.backuptransport"
  "com.google.android.pixel.setupwizard"
  "com.google.android.partnersetup"
  "com.google.android.onetimeinitializer"
  "com.google.android.apps.feedback"
  "com.google.android.safetycenter"
  "com.google.android.syncadapters.contacts"
  "com.google.android.syncadapters.calendar"
  "com.google.android.apps.recorder"
  "com.google.android.apps.pixel.callscreening"
  "com.google.android.apps.turbo"
  "com.google.android.apps.pixelstats"
  "com.android.chrome"
  "com.google.android.inputmethod.latin"
  "com.google.android.play.games"
  "com.google.android.apps.subscriptions.red"
  "com.google.android.apps.walletnfcrel"
  "com.google.android.projection.gearhead"
  "com.google.android.apps.magazines"
  "com.google.android.apps.translate"
)

# Get all User IDs (Main is usually 0, Work is usually 10+)
USER_IDS=$(adb shell pm list users | grep -oE '\{[0-9]+' | tr -d '{')

echo "Found User IDs: $USER_IDS"

for USER_ID in $USER_IDS; do
  echo "------------------------------------------------"
  echo "PROCESSING PROFILE: User $USER_ID"
  echo "------------------------------------------------"
  
  for PKG in "${PACKAGES[@]}"; do
    # Check if package exists for this specific user
    EXISTS=$(adb shell pm list packages --user "$USER_ID" | grep -q "^package:$PKG$" && echo "yes" || echo "no")
    
    if [ "$EXISTS" = "yes" ]; then
      # Attempt to disable
      RESULT=$(adb shell pm disable-user --user "$USER_ID" "$PKG" 2>&1)
      if [[ $RESULT == *"new state: disabled-user"* ]]; then
        echo "DISABLED [$USER_ID]: $PKG"
      else
        echo "FAILED   [$USER_ID]: $PKG (Likely protected system app)"
      fi
    else
      echo "NOT FOUND [$USER_ID]: $PKG"
    fi
  done
done

echo "=== Hardening Complete ==="