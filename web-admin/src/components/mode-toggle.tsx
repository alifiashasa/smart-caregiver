import { Moon, Sun } from 'lucide-react'
import { useTheme } from 'next-themes'

import { Button } from '@/components/ui/button'

export function ModeToggle() {
  const { resolvedTheme, setTheme } = useTheme()
  const isDark = resolvedTheme === 'dark'

  return (
    <Button
      aria-label="Toggle theme"
      onClick={() => setTheme(isDark ? 'light' : 'dark')}
      type="button"
      variant="outline"
    >
      {isDark ? <Sun /> : <Moon />}
      {isDark ? 'Light' : 'Dark'}
    </Button>
  )
}
