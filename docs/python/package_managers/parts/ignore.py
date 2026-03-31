from pathlib import Path
import fnmatch
from typing import Optional


class IgnoreParser:
    def __init__(self, root_path: Path, script_path: Optional[Path] = None):
        self.root_path = root_path
        self.script_path = script_path
        self.patterns = []
        self._load(".gitignore")
        self._load(".ignorecontext")
        self._add_special_patterns()

    def _load(self, filename):
        path = self.root_path / filename
        if path.exists():
            for line in path.read_text(encoding="utf-8").splitlines():
                line = line.strip()
                if line and not line.startswith("#"):
                    self.patterns.append(line)

    def _add_special_patterns(self):
        self.patterns += [".gitignore", ".ignorecontext"]

        if self.script_path:
            name = self.script_path.name
            self.patterns.append(name)

    def is_ignored(self, path: Path) -> bool:
        try:
            rel = path.relative_to(self.root_path)
        except ValueError:
            return False

        if ".git" in rel.parts:
            return True

        for pattern in self.patterns:
            if fnmatch.fnmatch(str(rel), pattern):
                return True
            if fnmatch.fnmatch(path.name, pattern):
                return True

        return False
