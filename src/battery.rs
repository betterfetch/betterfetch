use std::fs;
use std::path::Path;

/// Detect battery and return formatted battery info string
pub fn get_battery_info() -> Option<String> {
    let power_supply_path = Path::new("/sys/class/power_supply");

    if !power_supply_path.exists() {
        return None;
    }

    // Read directory entries
    let entries = match fs::read_dir(power_supply_path) {
        Ok(e) => e,
        Err(_) => return None,
    };

    // Look for battery entries (usually BAT0, BAT1, etc.)
    for entry in entries.flatten() {
        let path = entry.path();
        let name = path.file_name()?.to_str()?;

        // Check if this is a battery device
        if name.starts_with("BAT") {
            return read_battery_details(&path);
        }
    }

    None
}

fn read_battery_details(battery_path: &Path) -> Option<String> {
    // Read battery capacity (percentage)
    let capacity_path = battery_path.join("capacity");
    let capacity = fs::read_to_string(capacity_path).ok()?.trim().to_string();

    // Read battery status (Charging, Discharging, Full, etc.)
    let status_path = battery_path.join("status");
    let status = fs::read_to_string(status_path).ok()?.trim().to_string();

    // Format the output
    let status_display = match status.as_str() {
        "Charging" => "charging",
        "Discharging" => "discharging",
        "Full" => "full",
        "Not charging" => "not charging",
        _ => &status,
    };

    Some(format!("{}% ({})", capacity, status_display))
}
