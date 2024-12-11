import subprocess

def run_recover_script(disk, output_dir, pattern, mode):
    """
    Runs the recover.sh script with sudo and specified arguments.

    :param disk: Target disk/partition (e.g., /dev/nvme0n1p8).
    :param output_dir: Directory for recovered files.
    :param pattern: Regex pattern to match files (e.g., ".*").
    :param mode: Mode or action (e.g., "recover").
    :return: Dictionary with stdout, stderr, and return code.
    """
    try:
        result = subprocess.run(
            ["sudo", "./recover.sh", disk, output_dir, pattern, mode],
            capture_output=True,
            text=True
        )
        return {
            "stdout": result.stdout,
            "stderr": result.stderr,
            "return_code": result.returncode
        }
    except FileNotFoundError:
        return {
            "stdout": "",
            "stderr": "recover.sh not found or not executable.",
            "return_code": 1
        }
