#!/bin/bash
#
# Print banner art.

#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   GREEN
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {

  clear

  printf "\n\n"
  printf "${GREEN}";
  printf "INSTALL\n";
  printf "${NC}";
  printf "\n"
  printf "${GREY}";
  printf "NEXUS WHATICKET-SAAS\n";
  printf "by nexus | markagp.com.br | Development © 2025\n";
  printf "${NC}";
  printf "\n"
}
