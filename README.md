# Spam Bot Log Parser
This repository contains a script that is designed to extract and identify spammer bots that frequently appear in the logs of Minecraft servers. The script parses the log file, filters out the spam bot entries, and provides information about the unique IP addresses associated with the spammer bots along with their corresponding names.

## How to
Usage:

```bash
./spam-bot-parser.sh <log_file> [options]
```

Options:

- `-u`, `--unique`: Display only the unique IP addresses and their corresponding names.
- `-p`, `--ports`: Include the port numbers in the IP addresses.

Example usage:

```bash
./spam_bot_parser.sh ./logs/latest.log -u
```

Example output:
```csv
Bunger;3.xx.xx.xxx
Bunger;52.xx.xx.xxx
cuute;162.xx.xxx.xxx
cuute;45.xxx.xxx.xxx
```

Note: If you want to save the output, it can be easily done by using the `>` operator as shown below.

```bash
./spam_bot_parser.sh ./logs/latest.log -u > output.csv
```

## License

This project is licensed under the [MIT License](LICENSE).
