    ```python
    from typing import Dict


    def create_text_output(data: Dict) -> str:
        lines = []

        lines.append("=" * 80)
        lines.append(f"PATH: {data['root']}")
        lines.append(f"GENERATED: {data['generated_at']}")
        lines.append("=" * 80)
        lines.append("")

        # 🌳 TREE
        lines.append("DIRECTORY STRUCTURE")
        lines.append("-" * 40)
        lines.extend(data["tree"])
        lines.append("")

        # 📄 FILES
        lines.append("FILES")
        lines.append("-" * 40)

        for f in data["files"]:
            lines.append("")
            lines.append("=" * 60)
            lines.append(f"FILE: {f['path']}")
            lines.append(f"SIZE: {f['size']}")
            lines.append("=" * 60)

            if "content" in f:
                lines.append(f["content"])

        return "\n".join(lines)
    ```