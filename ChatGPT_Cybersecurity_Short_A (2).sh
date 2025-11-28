#!/bin/bash
###############################################################################
# CYBERSECURITY SCRIPT A (ChatGPT)
# Purpose: Simple, read‑only security check on THIS server (Ubuntu or CentOS).
# NOTE: This script does NOT change anything. It just shows info.
# Every line is commented so I can explain it in my documentation.
###############################################################################

# Create a small report file in my home folder with today's date.
REPORT="$HOME/cybersecurity_A_chatgpt_$(date +%F).txt"

# Use tee so I can see the output on screen AND save it in the report.
echo "===== CYBERSECURITY CHECK (CHATGPT SCRIPT A) =====" | tee "$REPORT"
echo "Date:     $(date)" | tee -a "$REPORT"
echo "Hostname: $(hostname)" | tee -a "$REPORT"
echo "User:     $(whoami)" | tee -a "$REPORT"
echo "==================================================" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

###############################################################################
# 1. BASIC SYSTEM INFO
###############################################################################

# Show which operating system this server is running.
echo "[1] OS information (/etc/os-release):" | tee -a "$REPORT"
cat /etc/os-release 2>/dev/null | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# Show which kernel version is running (useful for patch level).
echo "[1b] Kernel version (uname -r):" | tee -a "$REPORT"
uname -r | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

###############################################################################
# 2. USER ACCOUNTS (WHO CAN LOG IN)
###############################################################################

# List ONLY users that have a real login shell (bash or sh).
echo "[2] Users with a real login shell (possible login accounts):" | tee -a "$REPORT"
awk -F: '$7 ~ /(bash|sh)$/ {print "  - " $1 " (shell: " $7 ")"}' /etc/passwd | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

###############################################################################
# 3. SSH SECURITY SETTINGS
###############################################################################

# Check two important SSH options:
#  - PermitRootLogin: can root log in directly?
#  - PasswordAuthentication: are password logins allowed?
echo "[3] SSH security settings from /etc/ssh/sshd_config:" | tee -a "$REPORT"
grep -E '^(PermitRootLogin|PasswordAuthentication)' /etc/ssh/sshd_config 2>/dev/null | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

###############################################################################
# 4. FIREWALL STATUS (UFW OR FIREWALLD)
###############################################################################

echo "[4] Firewall status (if installed):" | tee -a "$REPORT"

# Check first for UFW (common on Ubuntu).
if command -v ufw >/dev/null 2>&1; then
  echo "  - UFW detected – current rules:" | tee -a "$REPORT"
  ufw status | tee -a "$REPORT"

# If UFW is not found, check for firewalld (common on CentOS).
elif command -v firewall-cmd >/dev/null 2>&1; then
  echo "  - firewalld detected – current zone details:" | tee -a "$REPORT"
  firewall-cmd --list-all 2>/dev/null | tee -a "$REPORT"

# If neither firewall tool is installed, just say so.
else
  echo "  - No UFW or firewalld installed on this server." | tee -a "$REPORT"
  echo "    (If I wanted, I could INSTALL a firewall here, e.g. ufw or firewalld.)" | tee -a "$REPORT"
fi
echo "" | tee -a "$REPORT"

###############################################################################
# 5. OPEN/LISTENING PORTS
###############################################################################

# Show which ports are listening for connections (TCP/UDP).
echo "[5] Listening TCP/UDP ports (ss -tuln):" | tee -a "$REPORT"
ss -tuln 2>/dev/null | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

###############################################################################
# 6. SUMMARY
###############################################################################

echo "===== END OF CHATGPT CYBERSECURITY CHECK (SCRIPT A) =====" | tee -a "$REPORT"
echo "Report saved to: $REPORT" | tee -a "$REPORT"
