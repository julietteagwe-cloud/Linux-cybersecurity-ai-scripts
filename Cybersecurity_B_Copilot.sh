#!/bin/bash
###############################################################################
# CYBERSECURITY SCRIPT B Copilot-
# Purpose: Do a SMALL hardening action on my lab server:
#   - Make sure I am root
#   - Check firewall tool
#   - INSTALL ufw on Ubuntu if it is missing
#   - Turn on a simple SSH-allowed firewall rule
#
# This gives me something clear to talk about when I answer:
#   "What installs did you make? What did you change to make the script work?"
###############################################################################

# Create a log file in my home folder so I can show the output later.
LOG="$HOME/cybersecurity_B_copilot_$(date +%F).log"

# log() prints to screen and saves to the log file.
log() {
  echo "$1" | tee -a "$LOG"
}

###############################################################################
# 1. REQUIRE ROOT / SUDO
###############################################################################

# Many firewall commands need root. If I'm not root, stop the script.
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run this script with sudo (example: sudo ./Cybersecurity_B_Copilot.sh)"
  exit 1
fi

###############################################################################
# 2. DETECT OS FAMILY (UBUNTU vs CENTOS)
###############################################################################

OS_FAMILY="unknown"

if [ -f /etc/os-release ]; then
  # Load variables like $ID from /etc/os-release
  . /etc/os-release

  case "$ID" in
    ubuntu|debian)
      OS_FAMILY="debian"
      ;;
    centos|rhel|rocky|almalinux)
      OS_FAMILY="rhel"
      ;;
    *)
      OS_FAMILY="other"
      ;;
  esac
fi

log "===== COPILOT CYBERSECURITY SCRIPT B ====="
log "Date:      $(date)"
log "OS family: $OS_FAMILY"
log "Log file:  $LOG"
log "=========================================="
log ""

###############################################################################
# 3. FIREWALL CONFIGURATION + INSTALL STEP
###############################################################################

log "[STEP 1] Firewall configuration and installs"

if [ "$OS_FAMILY" = "debian" ]; then
  # On Ubuntu/Debian we expect to use UFW.
  if ! command -v ufw >/dev/null 2>&1; then
    log "  - UFW is NOT installed. Installing ufw with apt (this is my main install)."
    apt update -y >> "$LOG" 2>&1
    apt install -y ufw >> "$LOG" 2>&1
  else
    log "  - UFW is already installed."
  fi

  # Basic safe rules for lab: deny all incoming, allow outgoing, allow SSH.
  ufw default deny incoming >> "$LOG" 2>&1
  ufw default allow outgoing >> "$LOG" 2>&1
  ufw allow ssh >> "$LOG" 2>&1
  ufw --force enable >> "$LOG" 2>&1
  log "  - UFW enabled with SSH allowed (safe default for my lab)."

elif [ "$OS_FAMILY" = "rhel" ]; then
  # On CentOS/RHEL we expect firewalld to already be there in the lab image.
  if command -v firewall-cmd >/dev/null 2>&1; then
    log "  - firewalld found. Using existing firewall on CentOS."
    firewall-cmd --set-default-zone=public >> "$LOG" 2>&1
    firewall-cmd --permanent --add-service=ssh >> "$LOG" 2>&1
    firewall-cmd --reload >> "$LOG" 2>&1
    log "  - firewalld reloaded with SSH service allowed."
  else
    log "  - No firewalld command found. (In my write‑up I can say CentOS already had its firewall or that I would install firewalld if needed.)"
  fi
else
  log "  - OS family unknown. Skipping firewall changes."
fi

log ""

###############################################################################
# 4. QUICK ACCOUNT REVIEW
###############################################################################

log "[STEP 2] Listing users with real login shells (bash/sh)"

# Show only accounts that can actually log in with a shell.
awk -F: '$7 ~ /(bash|sh)$/ {print \"    - \" $1 \" (shell: \" $7 \")\"}' /etc/passwd | tee -a "$LOG"

log ""
log "===== END OF COPILOT CYBERSECURITY SCRIPT B ====="

