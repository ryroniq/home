#!/bin/sh
free -mt | awk '
/^Mem:/   { mt = $2; ma = $7 }
/^Swap:/  { st = $2; su = $3 }
/^Total:/ { tt = $2; tu = $3 }
END {
  mu  = mt - ma                  # used = total - available
  pct = int(mu * 100 / mt)

  if      (pct >= 90) color = "#[fg=red]"
  else if (pct >= 75) color = "#[fg=yellow]"
  else                color = "#[fg=green]"

  printf "%s#[bold]mem#[none] %.1f/%.1fG (%d%%)#[fg=#eeeeee]", color, mu/1024, mt/1024, pct
  if (st > 0 && su > 0) printf " #[bold]swap#[none] %dM", su
  printf " #[bold]total#[none] %.1f/%.1fG", tu/1024, tt/1024
}'
