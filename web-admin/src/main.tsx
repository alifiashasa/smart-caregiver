import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { ThemeProvider } from 'next-themes'
import './index.css'
import App from './App.tsx'
import PrivacyPage from './PrivacyPage.tsx'

const isPrivacyPage = window.location.pathname.replace(/\/+$/, '') === '/privacy'

if (isPrivacyPage) {
  document.documentElement.lang = 'id'
  document.title = 'Kebijakan Privasi | Smart Caregiver'
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
      {isPrivacyPage ? <PrivacyPage /> : <App />}
    </ThemeProvider>
  </StrictMode>,
)
