import argparse
from pathlib import Path
import sys

from .ignore import IgnoreParser
from .core import create_json, save_json
from .core_text import create_text_output


def main():
    parser = argparse.ArgumentParser(description="Context Analyzer")

    parser.add_argument("path", help="Path to file or directory")

    parser.add_argument("-o", "--output", default="output.json", help="Output file")

    parser.add_argument(
        "--no-content",
        action="store_true",
        help="Skip file contents",
    )

    parser.add_argument(
        "--format",
        choices=["json", "txt", "both"],
        default="both",
        help="Output format",
    )

    args = parser.parse_args()

    input_path = Path(args.path).resolve()

    if not input_path.exists():
        print("Path does not exist")
        sys.exit(1)

    root = input_path if input_path.is_dir() else input_path.parent

    ignore = IgnoreParser(root, Path(sys.argv[0]).resolve())

    data = create_json(
        input_path,
        ignore,
        include_content=not args.no_content,
    )

    base_output = Path(args.output)

    # 👉 убираем расширение, если пользователь его указал
    base_output = base_output.with_suffix("")

    if args.format in ("json", "both"):
        json_file = base_output.with_suffix(".json")
        save_json(data, json_file)
        print(f"Saved JSON: {json_file}")

    if args.format in ("txt", "both"):
        txt_file = base_output.with_suffix(".txt")
        text = create_text_output(data)
        txt_file.write_text(text, encoding="utf-8")
        print(f"Saved TXT: {txt_file}")

    save_json(data, args.output)
