import { useEffect, useMemo, useState } from 'react'
import type { FormEvent, ReactNode } from 'react'
import { Bell, Database, Loader2, RadioTower } from 'lucide-react'
import { toast } from 'sonner'

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Checkbox } from '@/components/ui/checkbox'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { ModeToggle } from '@/components/mode-toggle'
import { Toaster } from '@/components/ui/sonner'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Textarea } from '@/components/ui/textarea'

type Operations = {
  system: {
    api: string
    database: string
    email_configured: boolean
    generated_at: string | null
  }
  caregivers: {
    total: number
    active: number
    inactive: number
    verified: number
    unverified: number
    new_last_7_days: number
  }
  sensitive_aggregate: {
    elderly_total: number
    elderly_critical: number
    health_records_total: number
    health_records_last_7_days: number
    warning_or_critical_records: number
  }
}

type Caregiver = {
  id: string
  email: string
  full_name: string
  phone: string | null
  is_active: boolean
  is_email_verified: boolean
  created_at: string | null
}

type Announcement = {
  announcement_id: string
  title: string
  target: {
    active?: string
    verified?: string
  }
  channels: string[]
  recipient_count: number
  created_at: string | null
}

type ListResponse<T> = {
  total?: number
  items: T[]
}

type ActiveTab = 'overview' | 'announcements' | 'caregivers'
type TargetActive = 'all' | 'active' | 'inactive'
type TargetVerified = 'all' | 'verified' | 'unverified'
type LoadingAction = 'load' | 'create-caregiver' | 'create-announcement' | `toggle-${string}` | null

const apiUrl = import.meta.env.VITE_API_URL ?? 'http://localhost:8000'
const normalizedApiUrl = apiUrl.replace(/\/$/, '')

const tabs: { key: ActiveTab; label: string }[] = [
  { key: 'overview', label: 'Overview' },
  { key: 'announcements', label: 'Announcements' },
  { key: 'caregivers', label: 'Caregivers' },
]

function formatDate(value: string | null) {
  if (!value) return '-'
  return new Intl.DateTimeFormat('id-ID', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(value))
}

function normalizeText(value: string) {
  return value.trim().replace(/\s+/g, ' ')
}

async function getErrorMessage(response: Response) {
  if (response.status >= 500) return `Request gagal (${response.status})`

  const contentType = response.headers.get('content-type') ?? ''
  if (contentType.includes('application/json')) {
    const body = (await response.json().catch(() => null)) as { detail?: unknown } | null
    if (typeof body?.detail === 'string') return body.detail
  }

  const text = await response.text().catch(() => '')
  return text.slice(0, 200) || `Request gagal (${response.status})`
}

function App() {
  const [adminKey, setAdminKey] = useState('')
  const [loginKey, setLoginKey] = useState('')
  const [activeTab, setActiveTab] = useState<ActiveTab>('overview')
  const [operations, setOperations] = useState<Operations | null>(null)
  const [caregivers, setCaregivers] = useState<ListResponse<Caregiver> | null>(null)
  const [announcements, setAnnouncements] = useState<ListResponse<Announcement> | null>(null)
  const [recipientCount, setRecipientCount] = useState(0)
  const [loadingAction, setLoadingAction] = useState<LoadingAction>(null)
  const [caregiverDialogOpen, setCaregiverDialogOpen] = useState(false)
  const [announcementDialogOpen, setAnnouncementDialogOpen] = useState(false)
  const [caregiverForm, setCaregiverForm] = useState({
    email: '',
    password: '',
    full_name: '',
    phone: '',
    is_email_verified: true,
  })
  const [announcementForm, setAnnouncementForm] = useState({
    title: '',
    body: '',
    active: 'active' as TargetActive,
    verified: 'all' as TargetVerified,
    in_app: true,
    email: true,
  })

  const headers = useMemo(
    () => ({
      'Content-Type': 'application/json',
      ...(adminKey ? { 'X-API-Key': adminKey } : {}),
    }),
    [adminKey],
  )

  async function request<T>(path: string, init?: RequestInit) {
    const response = await fetch(`${normalizedApiUrl}${path}`, {
      ...init,
      headers: {
        ...headers,
        ...init?.headers,
      },
    })

    if (!response.ok) {
      throw new Error(await getErrorMessage(response))
    }

    return response.json() as Promise<T>
  }

  async function loadData(showToast = false, keyOverride?: string) {
    setLoadingAction('load')
    try {
      const requestHeaders = keyOverride
        ? { 'Content-Type': 'application/json', 'X-API-Key': keyOverride }
        : headers
      const fetchAdmin = async <T,>(path: string) => {
        const response = await fetch(`${normalizedApiUrl}${path}`, { headers: requestHeaders })
        if (!response.ok) throw new Error(await getErrorMessage(response))
        return response.json() as Promise<T>
      }
      const [operationsData, caregiversData, announcementsData] = await Promise.all([
        fetchAdmin<Operations>('/admin/operations'),
        fetchAdmin<ListResponse<Caregiver>>('/admin/caregivers'),
        fetchAdmin<ListResponse<Announcement>>('/admin/announcements'),
      ])
      setOperations(operationsData)
      setCaregivers(caregiversData)
      setAnnouncements(announcementsData)
      if (showToast) toast.success('Data diperbarui')
    } catch (error) {
      if (keyOverride) throw error
      toast.error(error instanceof Error ? error.message : 'Gagal mengambil data')
    } finally {
      setLoadingAction(null)
    }
  }

  async function login(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const key = loginKey.trim()
    if (!key) {
      toast.error('Admin key wajib diisi')
      return
    }

    setLoadingAction('load')
    try {
      await loadData(false, key)
      setAdminKey(key)
      setLoginKey('')
      toast.success('Login berhasil')
    } catch (error) {
      setAdminKey('')
      toast.error(error instanceof Error ? error.message : 'Login gagal')
    } finally {
      setLoadingAction(null)
    }
  }

  function logout() {
    setAdminKey('')
    setOperations(null)
    setCaregivers(null)
    setAnnouncements(null)
    toast.success('Logout berhasil')
  }

  async function previewRecipients() {
    try {
      const result = await request<{ recipient_count: number }>('/admin/announcements/preview', {
        method: 'POST',
        body: JSON.stringify({
          target: {
            active: announcementForm.active,
            verified: announcementForm.verified,
          },
        }),
      })
      setRecipientCount(result.recipient_count)
    } catch {
      setRecipientCount(0)
    }
  }

  async function createCaregiver(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const phone = caregiverForm.phone.trim()
    const payload = {
      email: caregiverForm.email.trim().toLowerCase(),
      password: caregiverForm.password,
      full_name: normalizeText(caregiverForm.full_name),
      phone: phone || null,
      is_email_verified: caregiverForm.is_email_verified,
    }

    if (payload.password.length < 8) {
      toast.error('Password minimal 8 karakter')
      return
    }

    if (phone && !/^\+?[0-9\s-]{6,20}$/.test(phone)) {
      toast.error('Format nomor HP tidak valid')
      return
    }

    setLoadingAction('create-caregiver')
    try {
      await request('/admin/caregivers', {
        method: 'POST',
        body: JSON.stringify(payload),
      })
      toast.success(`Akun caregiver ${payload.full_name} berhasil dibuat`)
      setCaregiverDialogOpen(false)
      setCaregiverForm({ email: '', password: '', full_name: '', phone: '', is_email_verified: true })
      await loadData()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Gagal membuat akun caregiver')
      setLoadingAction(null)
    }
  }

  async function createAnnouncement(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const channels = [
      ...(announcementForm.in_app ? ['in_app'] : []),
      ...(announcementForm.email ? ['email'] : []),
    ]
    const title = normalizeText(announcementForm.title)
    const body = announcementForm.body.trim()

    if (!channels.length) {
      toast.error('Pilih minimal satu channel pengumuman')
      return
    }

    setLoadingAction('create-announcement')
    try {
      const result = await request<{
        recipient_count: number
        in_app_created: number
        email_sent: number
        email_failed: number
      }>('/admin/announcements', {
        method: 'POST',
        body: JSON.stringify({
          title,
          body,
          channels,
          target: {
            active: announcementForm.active,
            verified: announcementForm.verified,
          },
        }),
      })
      toast.success(
        `Terkirim ke ${result.recipient_count} caregiver. In-app ${result.in_app_created}, email ${result.email_sent}, gagal ${result.email_failed}.`,
      )
      setAnnouncementDialogOpen(false)
      setAnnouncementForm({ title: '', body: '', active: 'active', verified: 'all', in_app: true, email: true })
      await loadData()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Gagal mengirim pengumuman')
      setLoadingAction(null)
    }
  }

  async function toggleCaregiver(caregiver: Caregiver) {
    setLoadingAction(`toggle-${caregiver.id}`)
    try {
      await request(`/admin/caregivers/${caregiver.id}/status`, {
        method: 'PATCH',
        body: JSON.stringify({ is_active: !caregiver.is_active }),
      })
      toast.success(`${caregiver.full_name} berhasil ${caregiver.is_active ? 'dinonaktifkan' : 'diaktifkan'}`)
      await loadData()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Gagal mengubah status caregiver')
      setLoadingAction(null)
    }
  }

  useEffect(() => {
    if (!adminKey) return

    const id = window.setTimeout(() => {
      void loadData()
    }, 0)

    return () => window.clearTimeout(id)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminKey])

  useEffect(() => {
    if (!announcementDialogOpen) return

    const id = window.setTimeout(() => {
      void previewRecipients()
    }, 150)

    return () => window.clearTimeout(id)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [announcementDialogOpen, announcementForm.active, announcementForm.verified])

  const isLoading = loadingAction !== null

  if (!adminKey) {
    return (
      <main className="grid min-h-screen place-items-center bg-muted/30 px-4">
        <Toaster richColors position="top-right" />
        <Card className="w-full max-w-sm">
          <CardHeader>
            <CardTitle>Super Admin Login</CardTitle>
            <CardDescription>Masukkan admin key untuk mengakses dashboard.</CardDescription>
          </CardHeader>
          <CardContent>
            <form className="grid gap-4" onSubmit={(event) => void login(event)}>
              <div className="grid gap-2">
                <Label htmlFor="admin-key">Admin key</Label>
                <Input
                  autoComplete="current-password"
                  autoFocus
                  disabled={loadingAction === 'load'}
                  id="admin-key"
                  onChange={(event) => setLoginKey(event.target.value)}
                  type="password"
                  value={loginKey}
                />
              </div>
              <Button disabled={loadingAction === 'load'} type="submit">
                {loadingAction === 'load' ? <Loader2 className="animate-spin" /> : null}
                Login
              </Button>
            </form>
          </CardContent>
        </Card>
      </main>
    )
  }

  return (
    <main className="min-h-screen bg-muted/30">
      <Toaster richColors position="top-right" />
      <header className="sticky top-0 z-20 border-b bg-background/95 backdrop-blur">
        <div className="mx-auto flex max-w-6xl flex-col gap-4 px-4 py-4 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground">Smart Caregiver</p>
            <h1 className="text-2xl font-semibold tracking-tight">Operational Admin</h1>
          </div>
          <div className="flex flex-wrap gap-2">
            <nav className="flex flex-wrap gap-2">
              {tabs.map((tab) => (
                <Button
                  disabled={isLoading}
                  key={tab.key}
                  onClick={() => setActiveTab(tab.key)}
                  type="button"
                  variant={activeTab === tab.key ? 'default' : 'outline'}
                >
                  {tab.label}
                </Button>
              ))}
            </nav>
            <ModeToggle />
            <Button disabled={isLoading} onClick={logout} type="button" variant="outline">
              Logout
            </Button>
            <Button disabled={isLoading} onClick={() => void loadData(true)} type="button" variant="outline">
              {loadingAction === 'load' ? <Loader2 className="animate-spin" /> : null}
              Refresh
            </Button>
          </div>
        </div>
      </header>

      <div className="mx-auto grid max-w-6xl gap-6 px-4 py-6">
        {activeTab === 'overview' && operations ? (
          <section className="grid gap-6">
            <div className="grid gap-4 md:grid-cols-3">
              <MetricCard icon={<RadioTower />} label="API" value={operations.system.api} detail="FastAPI reachable" />
              <MetricCard icon={<Database />} label="Database" value={operations.system.database} detail="Query admin berhasil" />
              <MetricCard
                icon={<Bell />}
                label="Email"
                value={operations.system.email_configured ? 'configured' : 'not configured'}
                detail="Resend email"
              />
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <Card>
                <CardHeader>
                  <CardTitle>User aktif</CardTitle>
                </CardHeader>
                <CardContent className="grid gap-3 sm:grid-cols-3">
                  <NumberTile label="Total" value={operations.caregivers.total} />
                  <NumberTile label="Active" value={operations.caregivers.active} />
                  <NumberTile label="Inactive" value={operations.caregivers.inactive} />
                  <NumberTile label="Verified" value={operations.caregivers.verified} />
                  <NumberTile label="Unverified" value={operations.caregivers.unverified} />
                  <NumberTile label="Baru 7 hari" value={operations.caregivers.new_last_7_days} />
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Data aplikasi</CardTitle>
                </CardHeader>
                <CardContent className="grid gap-3 sm:grid-cols-2">
                  <NumberTile label="Total lansia" value={operations.sensitive_aggregate.elderly_total} />
                  <NumberTile label="Lansia critical" value={operations.sensitive_aggregate.elderly_critical} />
                  <NumberTile label="Health records" value={operations.sensitive_aggregate.health_records_total} />
                  <NumberTile label="Records 7 hari" value={operations.sensitive_aggregate.health_records_last_7_days} />
                  <NumberTile label="Warning/critical" value={operations.sensitive_aggregate.warning_or_critical_records} />
                </CardContent>
              </Card>
            </div>
          </section>
        ) : null}

        {activeTab === 'announcements' ? (
          <section className="grid gap-4">
            <div className="flex items-center justify-between gap-4">
              <div>
                <h2 className="text-xl font-semibold tracking-tight">App announcements</h2>
                <p className="text-sm text-muted-foreground">Kirim pengumuman aplikasi ke caregiver via in-app dan email.</p>
              </div>
              <Dialog open={announcementDialogOpen} onOpenChange={setAnnouncementDialogOpen}>
                <DialogTrigger asChild>
                  <Button disabled={isLoading} type="button">Buat pengumuman</Button>
                </DialogTrigger>
                <DialogContent className="sm:max-w-2xl">
                  <form onSubmit={(event) => void createAnnouncement(event)}>
                    <DialogHeader>
                      <DialogTitle>Buat pengumuman aplikasi</DialogTitle>
                      <DialogDescription>Maintenance, update fitur, atau info operasional aplikasi.</DialogDescription>
                    </DialogHeader>
                    <div className="grid gap-4 py-4">
                      <div className="grid gap-2">
                        <Label htmlFor="announcement-title">Judul</Label>
                        <Input
                          disabled={loadingAction === 'create-announcement'}
                          id="announcement-title"
                          maxLength={120}
                          minLength={3}
                          onChange={(event) => setAnnouncementForm({ ...announcementForm, title: event.target.value })}
                          required
                          value={announcementForm.title}
                        />
                      </div>
                      <div className="grid gap-2">
                        <Label htmlFor="announcement-body">Isi pesan</Label>
                        <Textarea
                          disabled={loadingAction === 'create-announcement'}
                          id="announcement-body"
                          maxLength={1200}
                          minLength={5}
                          onChange={(event) => setAnnouncementForm({ ...announcementForm, body: event.target.value })}
                          required
                          rows={5}
                          value={announcementForm.body}
                        />
                      </div>
                      <div className="grid gap-3 md:grid-cols-2">
                        <div className="grid gap-2">
                          <Label>Status akun</Label>
                          <Select
                            disabled={loadingAction === 'create-announcement'}
                            onValueChange={(value) => setAnnouncementForm({ ...announcementForm, active: value as TargetActive })}
                            value={announcementForm.active}
                          >
                            <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
                            <SelectContent>
                              <SelectItem value="active">Active only</SelectItem>
                              <SelectItem value="inactive">Inactive only</SelectItem>
                              <SelectItem value="all">Semua</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                        <div className="grid gap-2">
                          <Label>Email verification</Label>
                          <Select
                            disabled={loadingAction === 'create-announcement'}
                            onValueChange={(value) => setAnnouncementForm({ ...announcementForm, verified: value as TargetVerified })}
                            value={announcementForm.verified}
                          >
                            <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
                            <SelectContent>
                              <SelectItem value="all">Semua</SelectItem>
                              <SelectItem value="verified">Verified only</SelectItem>
                              <SelectItem value="unverified">Unverified only</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                      </div>
                      <div className="grid gap-2">
                        <Label>Channel</Label>
                        <div className="flex flex-wrap gap-4 rounded-lg border p-3">
                          <label className="flex items-center gap-2 text-sm">
                            <Checkbox
                              checked={announcementForm.in_app}
                              disabled={loadingAction === 'create-announcement'}
                              onCheckedChange={(checked) => setAnnouncementForm({ ...announcementForm, in_app: checked === true })}
                            />
                            In-app
                          </label>
                          <label className="flex items-center gap-2 text-sm">
                            <Checkbox
                              checked={announcementForm.email}
                              disabled={loadingAction === 'create-announcement'}
                              onCheckedChange={(checked) => setAnnouncementForm({ ...announcementForm, email: checked === true })}
                            />
                            Email
                          </label>
                        </div>
                      </div>
                      <div className="rounded-lg bg-muted p-3 text-sm">
                        Estimasi penerima: <strong>{recipientCount}</strong> caregiver
                      </div>
                    </div>
                    <DialogFooter>
                      <Button disabled={loadingAction === 'create-announcement'} type="submit">
                        {loadingAction === 'create-announcement' ? <Loader2 className="animate-spin" /> : null}
                        Kirim pengumuman
                      </Button>
                    </DialogFooter>
                  </form>
                </DialogContent>
              </Dialog>
            </div>

            <Card>
              <CardHeader>
                <CardTitle>Histori</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Judul</TableHead>
                      <TableHead>Target</TableHead>
                      <TableHead>Channel</TableHead>
                      <TableHead>Penerima</TableHead>
                      <TableHead>Waktu</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {(announcements?.items ?? []).map((announcement) => (
                      <TableRow key={announcement.announcement_id}>
                        <TableCell className="font-medium">{announcement.title}</TableCell>
                        <TableCell>{announcement.target.active ?? 'all'} / {announcement.target.verified ?? 'all'}</TableCell>
                        <TableCell>{announcement.channels.join(', ')}</TableCell>
                        <TableCell>{announcement.recipient_count}</TableCell>
                        <TableCell>{formatDate(announcement.created_at)}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </section>
        ) : null}

        {activeTab === 'caregivers' && caregivers ? (
          <section className="grid gap-4">
            <div className="flex items-center justify-between gap-4">
              <div>
                <h2 className="text-xl font-semibold tracking-tight">Caregivers</h2>
                <p className="text-sm text-muted-foreground">Create akun dan active/inactive.</p>
              </div>
              <Dialog open={caregiverDialogOpen} onOpenChange={setCaregiverDialogOpen}>
                <DialogTrigger asChild>
                  <Button disabled={isLoading} type="button">Buat caregiver</Button>
                </DialogTrigger>
                <DialogContent>
                  <form onSubmit={(event) => void createCaregiver(event)}>
                    <DialogHeader>
                      <DialogTitle>Buat akun caregiver</DialogTitle>
                    </DialogHeader>
                    <div className="grid gap-4 py-4">
                      <div className="grid gap-2">
                        <Label htmlFor="full-name">Nama lengkap</Label>
                        <Input
                          disabled={loadingAction === 'create-caregiver'}
                          id="full-name"
                          maxLength={255}
                          minLength={1}
                          onChange={(event) => setCaregiverForm({ ...caregiverForm, full_name: event.target.value })}
                          required
                          value={caregiverForm.full_name}
                        />
                      </div>
                      <div className="grid gap-2">
                        <Label htmlFor="email">Email</Label>
                        <Input
                          disabled={loadingAction === 'create-caregiver'}
                          id="email"
                          onChange={(event) => setCaregiverForm({ ...caregiverForm, email: event.target.value })}
                          required
                          type="email"
                          value={caregiverForm.email}
                        />
                      </div>
                      <div className="grid gap-2">
                        <Label htmlFor="password">Password awal</Label>
                        <Input
                          autoComplete="new-password"
                          disabled={loadingAction === 'create-caregiver'}
                          id="password"
                          maxLength={100}
                          minLength={8}
                          onChange={(event) => setCaregiverForm({ ...caregiverForm, password: event.target.value })}
                          required
                          type="password"
                          value={caregiverForm.password}
                        />
                      </div>
                      <div className="grid gap-2">
                        <Label htmlFor="phone">No. HP</Label>
                        <Input
                          disabled={loadingAction === 'create-caregiver'}
                          id="phone"
                          maxLength={20}
                          onChange={(event) => setCaregiverForm({ ...caregiverForm, phone: event.target.value })}
                          value={caregiverForm.phone}
                        />
                      </div>
                      <label className="flex items-center gap-2 text-sm">
                        <Checkbox
                          checked={caregiverForm.is_email_verified}
                          disabled={loadingAction === 'create-caregiver'}
                          onCheckedChange={(checked) => setCaregiverForm({ ...caregiverForm, is_email_verified: checked === true })}
                        />
                        Langsung tandai email verified
                      </label>
                    </div>
                    <DialogFooter>
                      <Button disabled={loadingAction === 'create-caregiver'} type="submit">
                        {loadingAction === 'create-caregiver' ? <Loader2 className="animate-spin" /> : null}
                        Buat akun
                      </Button>
                    </DialogFooter>
                  </form>
                </DialogContent>
              </Dialog>
            </div>

            <Card>
              <CardHeader>
                <CardTitle>Daftar caregiver</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Nama</TableHead>
                      <TableHead>Email</TableHead>
                      <TableHead>Verified</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Dibuat</TableHead>
                      <TableHead className="text-right">Aksi</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {caregivers.items.map((caregiver) => {
                      const rowLoading = loadingAction === `toggle-${caregiver.id}`

                      return (
                        <TableRow key={caregiver.id}>
                          <TableCell>
                            <div className="font-medium">{caregiver.full_name}</div>
                            <div className="text-xs text-muted-foreground">{caregiver.phone ?? 'Tanpa nomor'}</div>
                          </TableCell>
                          <TableCell>{caregiver.email}</TableCell>
                          <TableCell>
                            <Badge variant={caregiver.is_email_verified ? 'secondary' : 'outline'}>
                              {caregiver.is_email_verified ? 'verified' : 'unverified'}
                            </Badge>
                          </TableCell>
                          <TableCell>
                            <Badge variant={caregiver.is_active ? 'secondary' : 'destructive'}>
                              {caregiver.is_active ? 'active' : 'inactive'}
                            </Badge>
                          </TableCell>
                          <TableCell>{formatDate(caregiver.created_at)}</TableCell>
                          <TableCell className="text-right">
                            <AlertDialog>
                              <AlertDialogTrigger asChild>
                                <Button disabled={isLoading} type="button" variant="outline">
                                  {rowLoading ? <Loader2 className="animate-spin" /> : null}
                                  {caregiver.is_active ? 'Nonaktifkan' : 'Aktifkan'}
                                </Button>
                              </AlertDialogTrigger>
                              <AlertDialogContent>
                                <AlertDialogHeader>
                                  <AlertDialogTitle>
                                    {caregiver.is_active ? 'Nonaktifkan caregiver?' : 'Aktifkan caregiver?'}
                                  </AlertDialogTitle>
                                  <AlertDialogDescription>
                                    {caregiver.is_active
                                      ? `${caregiver.full_name} tidak bisa login sampai akun diaktifkan kembali.`
                                      : `${caregiver.full_name} akan bisa login kembali setelah akun diaktifkan.`}
                                  </AlertDialogDescription>
                                </AlertDialogHeader>
                                <AlertDialogFooter>
                                  <AlertDialogCancel disabled={rowLoading}>Batal</AlertDialogCancel>
                                  <AlertDialogAction disabled={rowLoading} onClick={() => void toggleCaregiver(caregiver)}>
                                    {rowLoading ? <Loader2 className="animate-spin" /> : null}
                                    {caregiver.is_active ? 'Nonaktifkan' : 'Aktifkan'}
                                  </AlertDialogAction>
                                </AlertDialogFooter>
                              </AlertDialogContent>
                            </AlertDialog>
                          </TableCell>
                        </TableRow>
                      )
                    })}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </section>
        ) : null}
      </div>
    </main>
  )
}

function MetricCard({ icon, label, value, detail }: { icon: ReactNode; label: string; value: string; detail: string }) {
  return (
    <Card>
      <CardHeader className="flex flex-row items-start justify-between space-y-0">
        <div>
          <CardDescription>{label}</CardDescription>
          <CardTitle className="mt-2 text-2xl capitalize">{value}</CardTitle>
        </div>
        <div className="rounded-lg bg-muted p-2 text-muted-foreground">{icon}</div>
      </CardHeader>
      <CardContent className="text-sm text-muted-foreground">{detail}</CardContent>
    </Card>
  )
}

function NumberTile({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-lg border bg-muted/30 p-3">
      <div className="text-xs font-medium uppercase tracking-wide text-muted-foreground">{label}</div>
      <div className="mt-1 text-2xl font-semibold">{value}</div>
    </div>
  )
}

export default App
