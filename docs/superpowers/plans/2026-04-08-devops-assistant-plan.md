# 运维助手 (HarmonyOps) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile DevSecOps application in HarmonyOS (ArkUI) for server monitoring, alerting, SSH terminal access, and script execution, applying a high-contrast dark theme ("Precision in Darkness").

**Architecture:** Pure ArkUI frontend using a bottom navigation tab structure. Connects to cloud RESTful/WebSocket APIs for data and operations. Modular design separating Dashboard, Terminal, Alerts, and Scripts.

**Tech Stack:** HarmonyOS, ArkUI (ArkTS), `@ohos.net.http`, `@ohos.websockets`, `@ohos.data.preferences`

---

### Task 1: Foundation and Theming Setup

**Files:**
- Create: `entry/src/main/ets/theme/Theme.ets`
- Modify: `entry/src/main/ets/entryability/EntryAbility.ets`
- Create: `entry/src/main/ets/pages/MainPage.ets`
- Modify: `entry/src/main/ets/pages/Index.ets`

- [ ] **Step 1: Define Theme Constants**

Create `entry/src/main/ets/theme/Theme.ets`:
```typescript
export class Theme {
  static readonly PRIMARY = '#a78bfa';
  static readonly BACKGROUND = '#09090b';
  static readonly TERTIARY = '#34d399';
  static readonly ERROR = '#ef4444';
  
  static readonly SURFACE_0 = '#0c0c0f';
  static readonly SURFACE_1 = '#18181b';
  static readonly SURFACE_2 = '#27272a';

  static readonly TEXT_PRIMARY = '#fafafa';
  static readonly TEXT_SECONDARY = '#a1a1aa';

  static readonly BORDER_RADIUS = 8;
  static readonly BORDER_WIDTH = 1;
}
```

- [ ] **Step 2: Setup Main Application Entry Point**

Modify `entry/src/main/ets/pages/Index.ets` to redirect to MainPage and apply global background:
```typescript
import router from '@ohos.router';
import { Theme } from '../theme/Theme';

@Entry
@Component
struct Index {
  onPageShow() {
    router.replaceUrl({ url: 'pages/MainPage' });
  }

  build() {
    Column() {
      Text('Loading...')
        .fontColor(Theme.TEXT_PRIMARY)
        .fontSize(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
    .justifyContent(FlexAlign.Center)
  }
}
```

- [ ] **Step 3: Build the Main Tab Navigation**

Create `entry/src/main/ets/pages/MainPage.ets`:
```typescript
import { Theme } from '../theme/Theme';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        Column() {
          Text('Dashboard Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('概览', 0))

      TabContent() {
        Column() {
          Text('Terminal Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('终端', 1))

      TabContent() {
        Column() {
          Text('Alerts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('告警', 2))

      TabContent() {
        Column() {
          Text('Scripts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('工具', 3))
    }
    .scrollable(false)
    .backgroundColor(Theme.SURFACE_0)
    .barBackgroundColor(Theme.SURFACE_1)
    .barHeight(50)
  }
}
```

- [ ] **Step 4: Commit Foundation Setup**

Run:
```bash
git add entry/src/main/ets/theme/Theme.ets entry/src/main/ets/pages/MainPage.ets entry/src/main/ets/pages/Index.ets
git commit -m "feat: setup dark theme and main tab navigation"
```

---

### Task 2: Dashboard Component

**Files:**
- Create: `entry/src/main/ets/components/Card.ets`
- Create: `entry/src/main/ets/pages/dashboard/DashboardTab.ets`
- Modify: `entry/src/main/ets/pages/MainPage.ets`

- [ ] **Step 1: Create reusable Card component**

Create `entry/src/main/ets/components/Card.ets`:
```typescript
import { Theme } from '../theme/Theme';

@Component
export struct Card {
  @BuilderParam content: () => void;

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Theme.SURFACE_1)
    .borderRadius(Theme.BORDER_RADIUS)
    .border({ width: Theme.BORDER_WIDTH, color: Theme.SURFACE_2, style: BorderStyle.Solid })
    .margin({ bottom: 12 })
  }
}
```

- [ ] **Step 2: Build Dashboard Tab Content**

Create `entry/src/main/ets/pages/dashboard/DashboardTab.ets`:
```typescript
import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct DashboardTab {
  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Text('概览').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        }.width('100%').padding({ top: 16, bottom: 24, left: 16, right: 16 })

        // Stats Card
        Card() {
          Column() {
            Text('服务器健康度').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 12 })
            Row() {
              Column() {
                Text('总数').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
                Text('12').fontSize(28).fontColor(Theme.PRIMARY).fontWeight(FontWeight.Bold)
              }.alignItems(HorizontalAlign.Start).width('50%')
              Column() {
                Text('异常').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
                Text('0').fontSize(28).fontColor(Theme.TERTIARY).fontWeight(FontWeight.Bold)
              }.alignItems(HorizontalAlign.Start).width('50%')
            }.width('100%')
          }.alignItems(HorizontalAlign.Start).width('100%')
        }

        // Mock Server Card
        Card() {
          Column() {
            Text('web-server-01').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 8 })
            Text('CPU: 45%').fontSize(14).fontColor(Theme.TEXT_SECONDARY)
            Progress({ value: 45, total: 100, type: ProgressType.Linear })
              .color(Theme.PRIMARY).backgroundColor(Theme.SURFACE_2).margin({ top: 4, bottom: 8 })
            
            Text('RAM: 2.1GB / 4GB').fontSize(14).fontColor(Theme.TEXT_SECONDARY)
            Progress({ value: 52, total: 100, type: ProgressType.Linear })
              .color(Theme.PRIMARY).backgroundColor(Theme.SURFACE_2).margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start).width('100%')
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}
```

- [ ] **Step 3: Integrate Dashboard into MainPage**

Modify `entry/src/main/ets/pages/MainPage.ets`:
```typescript
import { Theme } from '../theme/Theme';
import { DashboardTab } from './dashboard/DashboardTab';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        DashboardTab()
      }.tabBar(this.TabBuilder('概览', 0))

      TabContent() {
        Column() {
          Text('Terminal Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('终端', 1))

      TabContent() {
        Column() {
          Text('Alerts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('告警', 2))

      TabContent() {
        Column() {
          Text('Scripts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('工具', 3))
    }
    .scrollable(false)
    .backgroundColor(Theme.SURFACE_0)
    .barBackgroundColor(Theme.SURFACE_1)
    .barHeight(50)
  }
}
```

- [ ] **Step 4: Commit Dashboard**

Run:
```bash
git add entry/src/main/ets/components/Card.ets entry/src/main/ets/pages/dashboard/DashboardTab.ets entry/src/main/ets/pages/MainPage.ets
git commit -m "feat: implement dashboard tab with server metrics"
```

---

### Task 3: Alerts Component

**Files:**
- Create: `entry/src/main/ets/pages/alerts/AlertsTab.ets`
- Modify: `entry/src/main/ets/pages/MainPage.ets`

- [ ] **Step 1: Build Alerts Tab Content**

Create `entry/src/main/ets/pages/alerts/AlertsTab.ets`:
```typescript
import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct AlertsTab {
  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Text('告警通知').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        }.width('100%').padding({ top: 16, bottom: 24, left: 16, right: 16 })

        // Mock Alert Card 1 (Unresolved)
        Card() {
          Row() {
            Column() {
              Text('CPU Usage High').fontSize(16).fontColor(Theme.ERROR).fontWeight(FontWeight.Bold).margin({ bottom: 4 })
              Text('db-server-01 CPU > 90% for 5 mins').fontSize(14).fontColor(Theme.TEXT_SECONDARY).margin({ bottom: 8 })
              Text('10 mins ago').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Button('Acknowledge')
              .fontSize(12)
              .fontColor(Theme.TEXT_PRIMARY)
              .backgroundColor(Theme.SURFACE_2)
              .border({ width: 1, color: Theme.TEXT_SECONDARY, style: BorderStyle.Solid })
              .height(30)
          }.width('100%').alignItems(VerticalAlign.Center)
        }

        // Mock Alert Card 2 (Resolved)
        Card() {
          Row() {
            Column() {
              Text('Disk Space Warning').fontSize(16).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold).margin({ bottom: 4 })
              Text('cache-01 disk > 80%').fontSize(14).fontColor(Theme.TEXT_SECONDARY).margin({ bottom: 8 })
              Text('2 hours ago').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Text('Resolved').fontSize(12).fontColor(Theme.TERTIARY)
          }.width('100%').alignItems(VerticalAlign.Center)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}
```

- [ ] **Step 2: Integrate Alerts into MainPage**

Modify `entry/src/main/ets/pages/MainPage.ets` to include AlertsTab:
```typescript
import { Theme } from '../theme/Theme';
import { DashboardTab } from './dashboard/DashboardTab';
import { AlertsTab } from './alerts/AlertsTab';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        DashboardTab()
      }.tabBar(this.TabBuilder('概览', 0))

      TabContent() {
        Column() {
          Text('Terminal Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('终端', 1))

      TabContent() {
        AlertsTab()
      }.tabBar(this.TabBuilder('告警', 2))

      TabContent() {
        Column() {
          Text('Scripts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('工具', 3))
    }
    .scrollable(false)
    .backgroundColor(Theme.SURFACE_0)
    .barBackgroundColor(Theme.SURFACE_1)
    .barHeight(50)
  }
}
```

- [ ] **Step 3: Commit Alerts**

Run:
```bash
git add entry/src/main/ets/pages/alerts/AlertsTab.ets entry/src/main/ets/pages/MainPage.ets
git commit -m "feat: implement alerts tab"
```

---

### Task 4: Scripts Component

**Files:**
- Create: `entry/src/main/ets/pages/scripts/ScriptsTab.ets`
- Modify: `entry/src/main/ets/pages/MainPage.ets`

- [ ] **Step 1: Build Scripts Tab Content**

Create `entry/src/main/ets/pages/scripts/ScriptsTab.ets`:
```typescript
import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct ScriptsTab {
  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Text('常用工具').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        }.width('100%').padding({ top: 16, bottom: 24, left: 16, right: 16 })

        // Script 1
        Card() {
          Row() {
            Column() {
              Text('Restart Nginx').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 4 })
              Text('systemctl restart nginx').fontSize(14).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace')
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Button('Run')
              .fontSize(12)
              .fontColor(Theme.TEXT_PRIMARY)
              .backgroundColor(Theme.PRIMARY)
              .height(30)
          }.width('100%').alignItems(VerticalAlign.Center)
        }

        // Script 2
        Card() {
          Row() {
            Column() {
              Text('Clear Cache').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 4 })
              Text('rm -rf /var/cache/app/*').fontSize(14).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace')
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Button('Run')
              .fontSize(12)
              .fontColor(Theme.TEXT_PRIMARY)
              .backgroundColor(Theme.PRIMARY)
              .height(30)
          }.width('100%').alignItems(VerticalAlign.Center)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}
```

- [ ] **Step 2: Integrate Scripts into MainPage**

Modify `entry/src/main/ets/pages/MainPage.ets` to include ScriptsTab:
```typescript
import { Theme } from '../theme/Theme';
import { DashboardTab } from './dashboard/DashboardTab';
import { AlertsTab } from './alerts/AlertsTab';
import { ScriptsTab } from './scripts/ScriptsTab';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        DashboardTab()
      }.tabBar(this.TabBuilder('概览', 0))

      TabContent() {
        Column() {
          Text('Terminal Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('终端', 1))

      TabContent() {
        AlertsTab()
      }.tabBar(this.TabBuilder('告警', 2))

      TabContent() {
        ScriptsTab()
      }.tabBar(this.TabBuilder('工具', 3))
    }
    .scrollable(false)
    .backgroundColor(Theme.SURFACE_0)
    .barBackgroundColor(Theme.SURFACE_1)
    .barHeight(50)
  }
}
```

- [ ] **Step 3: Commit Scripts**

Run:
```bash
git add entry/src/main/ets/pages/scripts/ScriptsTab.ets entry/src/main/ets/pages/MainPage.ets
git commit -m "feat: implement scripts tab"
```

---

### Task 5: Terminal Component (Mock UI)

**Files:**
- Create: `entry/src/main/ets/pages/terminal/TerminalTab.ets`
- Modify: `entry/src/main/ets/pages/MainPage.ets`

- [ ] **Step 1: Build Terminal Tab Content**

Create `entry/src/main/ets/pages/terminal/TerminalTab.ets`:
```typescript
import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct TerminalTab {
  build() {
    Column() {
      // Header
      Row() {
        Text('服务器终端').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
      }.width('100%').padding({ top: 16, bottom: 16, left: 16, right: 16 })

      // Server List
      Scroll() {
        Column() {
          Card() {
            Row() {
              Column() {
                Text('web-server-01').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 4 })
                Text('192.168.1.101').fontSize(14).fontColor(Theme.TEXT_SECONDARY)
              }.alignItems(HorizontalAlign.Start).layoutWeight(1)
              
              Button('Connect')
                .fontSize(12)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .border({ width: 1, color: Theme.PRIMARY, style: BorderStyle.Solid })
                .height(30)
            }.width('100%').alignItems(VerticalAlign.Center)
          }

          // Mock Terminal Output Area
          Column() {
            Text('root@web-server-01:~# tail -f /var/log/syslog')
              .fontSize(12).fontColor(Theme.TEXT_PRIMARY).fontFamily('monospace').width('100%').margin({ bottom: 4 })
            Text('Apr  8 12:00:01 web-server CRON[1234]: pam_unix(cron:session): session opened for user root')
              .fontSize(12).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace').width('100%').margin({ bottom: 4 })
            Text('Apr  8 12:05:01 web-server systemd[1]: Started Clean php session files.')
              .fontSize(12).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace').width('100%')
          }
          .width('100%')
          .height(300)
          .backgroundColor('#000000') // Darker than background for terminal feel
          .borderRadius(Theme.BORDER_RADIUS)
          .padding(12)
          .margin({ top: 16 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}
```

- [ ] **Step 2: Integrate Terminal into MainPage**

Modify `entry/src/main/ets/pages/MainPage.ets` to include TerminalTab:
```typescript
import { Theme } from '../theme/Theme';
import { DashboardTab } from './dashboard/DashboardTab';
import { TerminalTab } from './terminal/TerminalTab';
import { AlertsTab } from './alerts/AlertsTab';
import { ScriptsTab } from './scripts/ScriptsTab';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        DashboardTab()
      }.tabBar(this.TabBuilder('概览', 0))

      TabContent() {
        TerminalTab()
      }.tabBar(this.TabBuilder('终端', 1))

      TabContent() {
        AlertsTab()
      }.tabBar(this.TabBuilder('告警', 2))

      TabContent() {
        ScriptsTab()
      }.tabBar(this.TabBuilder('工具', 3))
    }
    .scrollable(false)
    .backgroundColor(Theme.SURFACE_0)
    .barBackgroundColor(Theme.SURFACE_1)
    .barHeight(50)
  }
}
```

- [ ] **Step 3: Commit Terminal**

Run:
```bash
git add entry/src/main/ets/pages/terminal/TerminalTab.ets entry/src/main/ets/pages/MainPage.ets
git commit -m "feat: implement terminal tab mockup"
```
