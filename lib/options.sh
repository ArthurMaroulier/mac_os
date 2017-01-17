#! /usr/bin/env bash

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
process_option() {
  case $1 in
    'B')
      bin/create_boot_disk;;
    'b')
      bin/apply_basic_settings;;
    't')
      bin/install_dev_tools;;
    'h')
      bin/install_homebrew;;
    'n')
      bin/install_npm_modules;;
    'H')
      bin/install_cask;;
    'm')
      bin/install_app_store;;
    'a')
      bin/install_applications;;
    'x')
      bin/install_extensions;;
    'd')
      bin/apply_default_settings;;
    's')
      bin/setup_software;;
    'p')
      bin/install_php;;
    'i')
      caffeinate_machine
      bin/apply_basic_settings
      bin/install_dev_tools
      bin/install_homebrew
      bin/install_npm_modules
      bin/install_cask
      bin/install_app_store
      bin/install_applications
      bin/install_extensions
      bin/apply_default_settings
      bin/setup_software
      bin/install_php
      bin/restore_ssh_files
      clean_work_path;;
    'R')
      bin/restore_backup;;
    'S')
      bin/restore_ssh_files;;
    'c')
      verify_homebrews
      verify_applications
      verify_casks
      verify_mas
      verify_extensions;;
    'C')
      caffeinate_machine;;
    'ua')
      uninstall_application;;
    'ux')
      uninstall_extension;;
    'ra')
      reinstall_application;;
    'rx')
      reinstall_extension;;
    'w')
      clean_work_path;;
    'q');;
    *)
      printf "ERROR: Invalid option.\n";;
  esac
}
export -f process_option
