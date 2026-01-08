#!/bin/bash
set -e

# Run the Ansible playbook
if [ "$EUID" -eq 0 ]; then
    ansible-playbook playbook.yml -e ansible_become=false "$@"
    PLAYBOOK_EXIT=$?
else
    ansible-playbook playbook.yml --ask-become-pass "$@"
    PLAYBOOK_EXIT=$?
fi

# After playbook completes successfully, show instructions
if [ $PLAYBOOK_EXIT -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "✅ INSTALLATION COMPLETE!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "🔄 CHANGE USER NOW with:"
    echo ""
    echo "    sudo -i -u clawdbot"
    echo ""
    echo "This will switch you to the clawdbot user and show"
    echo "the next setup steps (configuration, provider login, etc.)"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo ""
else
    echo "❌ Playbook failed with exit code $PLAYBOOK_EXIT"
    exit $PLAYBOOK_EXIT
fi
