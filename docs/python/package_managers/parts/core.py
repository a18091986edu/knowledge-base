    ```python
    from pathlib import Path
    from typing import List
    from datetime import datetime
    import json

    MAX_FILE_SIZE = 1_000_000


    def is_binary(file_path: Path) -> bool:
        try:
            with open(file_path, "rb") as f:
                return b"\0" in f.read(1024)
        except Exception:
            return True


    def read_file_content(file_path: Path) -> str:
        if file_path.stat().st_size > MAX_FILE_SIZE:
            return "[FILE TOO LARGE]"

        if is_binary(file_path):
            return "[BINARY FILE]"

        try:
            return file_path.read_text(encoding="utf-8")
        except Exception:
            return "[READ ERROR]"


    def collect_files(path: Path, ignore) -> List[Path]:
        result = []

        if ignore.is_ignored(path):
            return result

        if path.is_dir():
            for item in path.iterdir():
                result.extend(collect_files(item, ignore))
        else:
            result.append(path)

        return result


    def build_tree(
        path: Path,
        ignore,
        prefix: str = "",
        is_last: bool = True,
    ) -> List[str]:
        if ignore.is_ignored(path):
            return []

        connector = "└── " if is_last else "├── "
        line = f"{prefix}{connector}{path.name}"

        if path.is_dir():
            line += "/"

        lines = [line]

        if path.is_dir():
            try:
                items = sorted(
                    [p for p in path.iterdir() if not ignore.is_ignored(p)],
                    key=lambda x: (not x.is_dir(), x.name.lower()),
                )

                for i, item in enumerate(items):
                    is_last_item = i == len(items) - 1
                    new_prefix = prefix + ("    " if is_last else "│   ")

                    lines.extend(build_tree(item, ignore, new_prefix, is_last_item))
            except PermissionError:
                lines.append(prefix + "    [ACCESS DENIED]")

        return lines


    def create_json(input_path: Path, ignore, include_content=True):
        files = collect_files(input_path, ignore)
        tree = build_tree(input_path, ignore)

        data = {
            "root": str(input_path),
            "generated_at": datetime.now().isoformat(),
            "tree": tree,
            "files": [],
        }

        from tqdm import tqdm

        for f in tqdm(files, desc="Processing files"):
            entry = {
                "path": str(f),
                "size": f.stat().st_size,
            }

            if include_content:
                entry["content"] = read_file_content(f)

            data["files"].append(entry)

        return data


    def save_json(data, output):
        Path(output).write_text(
            json.dumps(data, indent=2, ensure_ascii=False),
            encoding="utf-8",
        )
    ```