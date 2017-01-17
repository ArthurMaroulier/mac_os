#! /usr/bin/env bash

# DESCRIPTION
# Defines verification/validation functions.

# Verifies if installed software are effectively present.
# Parameters:
# $1 = The software name.
# $2 = The installed software names list.
verify_installed_software_presence() {
  local application="$1"
  local applications="$2"

  if [[ "${applications[*]}" != *"$application"* ]]; then
    printf " - Missing: $application\n"
  fi
}
export -f verify_installed_software_presence

# Checks for missing Homebrew software.
verify_homebrews() {
  printf "Checking Homebrew software presence...\n"

  local applications="$(brew list)"

  for software in "${HOMEBREW_SOFTWARE[@]}"
  do
    # Exception: "gpg" is the binary but is listed as "gnugp".
    if [[ "$software" == "gpg" ]]; then
      software="gnupg"
    fi

    # Exception: "hg" is the binary but is listed as "mercurial".
    if [[ "$software" == "hg" ]]; then
      software="mercurial"
    fi

    verify_installed_software_presence "$software" "${applications[*]}"
  done

  printf "Homebrew check complete.\n"
}
export -f verify_homebrews

# Checks for missing Homebrew Cask apps.
verify_casks() {
  printf "Checking Homebrew Cask apps presence...\n"

  local applications="$(brew cask list)"

  for cask_app in "${CASK_APPS[@]}"
  do
    verify_installed_software_presence "$cask_app" "${applications[*]}"
  done

  printf "Homebrew Cask apps check complete.\n"
}
export -f verify_casks

# Checks for missing Mac App Store apps.
verify_mas() {
  printf "Checking Mac App Store apps presence...\n"

  local applications="$(mas list)"

  for mas_app in "${MAS_APPS[@]}"
  do
    verify_installed_software_presence "$mas_app" "${applications[*]}"
  done

  printf "Mac App Store apps check complete.\n"
}
export -f verify_mas

# Verifies application exists.
# Parameters:
# $1 = The file name.
verify_application() {
  local file_name="$1"

  # Display the missing install if not found.
  local install_path=$(get_install_path "$file_name")

  if [[ ! -e "$install_path" ]]; then
    printf " - Missing: $file_name\n"
  fi
}
export -f verify_application

# Checks for missing applications suffixed by "APP_NAME" as defined in settings.sh.
verify_applications() {
  printf "\nChecking application software...\n"

  # Only use environment keys that end with "APP_NAME".
  local file_names=$(set | awk -F "=" '{print $1}' | grep ".*APP_NAME")

  # For each application name, check to see if the application is installed. Otherwise, skip.
  for name in $file_names; do
    # Pass the key value to verfication.
    verify_application "${!name}"
  done

  printf "Application software check complete.\n"
}
export -f verify_applications

# Verifies path exists.
# Parameters:
# $1 = The path.
verify_path() {
  local path="$1"

  # Display the missing path if not found.
  if [[ ! -e "$path" ]]; then
    printf " - Missing: $path\n"
  fi
}
export -f verify_path

# Checks for missing extensions suffixed by "EXTENSION_PATH" as defined in settings.sh.
verify_extensions() {
  printf "\nChecking application extensions...\n"

  # Only use environment keys that end with "EXTENSION_PATH".
  local extensions=$(set | awk -F "=" '{print $1}' | grep ".*EXTENSION_PATH")

  # For each extension, check to see if the extension is installed. Otherwise, skip.
  for extension in $extensions; do
    # Evaluate/extract the key (extension) value and pass it on for verfication.
    verify_path "${!extension}"
  done

  printf "Application extension check complete.\n"
}
export -f verify_extensions
