#!/usr/bin/env bash
# =============================================================================
# Plugin: codewiz
# Description: Display Codewiz LLM usage (used / limit) for current month
# Dependencies: curl, jq
# =============================================================================
#
# CONTRACT IMPLEMENTATION:
#
# State:
#   - active:   Usage data fetched successfully
#   - failed:   API unreachable or returned no data (still visible)
#
# Health:
#   - ok:       used < 70% of limit
#   - warning:  70% <= used < 90%
#   - error:    used >= 90%
#
# =============================================================================

POWERKIT_ROOT="${POWERKIT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
. "${POWERKIT_ROOT}/src/contract/plugin_contract.sh"

# =============================================================================
# Plugin Contract: Metadata
# =============================================================================

plugin_get_metadata() {
    metadata_set "id" "codewiz"
    metadata_set "name" "Codewiz"
    metadata_set "description" "Display Codewiz LLM token usage for current month"
}

# =============================================================================
# Plugin Contract: Dependencies
# =============================================================================

plugin_check_dependencies() {
    require_cmd "curl" || return 1
    require_cmd "jq"   || return 1
    return 0
}

# =============================================================================
# Plugin Contract: Options
# =============================================================================

plugin_declare_options() {
    declare_option "user_email"          "string" "liuguangqi@xiaohongshu.com" "Codewiz user email"
    declare_option "warning_threshold"   "number" "70"   "Warning threshold (% of limit)"
    declare_option "critical_threshold"  "number" "90"   "Critical threshold (% of limit)"
    declare_option "icon"                "icon"   $'\UEE16' "Plugin icon (nerd font)"
    declare_option "cache_ttl"           "number" "1800"  "Cache TTL in seconds (30 min)"
}

# =============================================================================
# Plugin Contract: Type and Presence
# =============================================================================

plugin_get_content_type() { printf 'dynamic'; }
plugin_get_presence()     { printf 'always'; }

# =============================================================================
# Plugin Contract: State and Health
# =============================================================================

plugin_get_state() {
    local available
    available=$(plugin_data_get "available")
    [[ "$available" == "1" ]] && printf 'active' || printf 'failed'
}

plugin_get_health() {
    local pct warn crit
    pct=$(plugin_data_get "pct")
    [[ -z "$pct" ]] && { printf 'error'; return; }

    warn=$(get_option "warning_threshold")
    crit=$(get_option "critical_threshold")

    if (( pct >= crit )); then
        printf 'error'
    elif (( pct >= warn )); then
        printf 'warning'
    else
        printf 'ok'
    fi
}

plugin_get_icon() { get_option "icon"; }

# =============================================================================
# Plugin Contract: Data Collection
# =============================================================================

plugin_collect() {
    local email
    email=$(get_option "user_email")

    local response
    response=$(curl -s --connect-timeout 8 -G \
        "https://codewiz.devops.xiaohongshu.com/llmadapter/agent/models" \
        --data-urlencode "clientType=WEB" \
        --data-urlencode "version=0.10.2" \
        --data-urlencode "userEmail=${email}" 2>/dev/null)

    [[ -z "$response" ]] && return 1

    local used limit
    used=$(printf '%s' "$response" | jq -r '.data.costUsage.used // empty' 2>/dev/null)
    limit=$(printf '%s' "$response" | jq -r '.data.costUsage.limit // empty' 2>/dev/null)

    [[ -z "$used" || -z "$limit" || "$limit" == "0" ]] && return 1

    # Calculate remaining as integer
    local remaining pct
    remaining=$(awk -v u="$used" -v l="$limit" 'BEGIN { printf "%d", l - u }')
    pct=$(awk -v u="$used" -v l="$limit" 'BEGIN { printf "%d", (u / l) * 100 }')

    plugin_data_set "remaining"  "$remaining"
    plugin_data_set "limit"      "$limit"
    plugin_data_set "pct"        "$pct"
    plugin_data_set "available"  "1"
}

# =============================================================================
# Plugin Contract: Render (TEXT ONLY)
# =============================================================================

plugin_render() {
    local remaining
    remaining=$(plugin_data_get "remaining")

    if [[ -z "$remaining" ]]; then
        printf 'N/A'
        return
    fi

    printf '$%s' "$remaining"
}
