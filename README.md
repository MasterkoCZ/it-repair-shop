# IT Repair Shop Tycoon

## 1. Základní koncepce
"IT Repair Shop Tycoon" je 2D simulace a tycoon hra s pixel art stylem, vytvořená v Godot Engine. Hráč se stává majitelem podzemní IT opravny, kde spravuje zákazníky, opravuje zařízení (telefony, počítače - budou přidány později) a rozvíjí svůj podnik. Hratelnost stojí na organizaci práce, rychlém řešení poruch a budování reputace. Zábava plyne z rozšiřování opravny a zvyšování efektivity.

- **Úvodní studie:** Hra je provedená v Godot 4 s jednoduchými 2D mechanikami. Zdroje: Godot, Pixelorama pro grafiku, Audacity pro zvuky, půjčená 8-bit hudba.
- **Hrubý popis:** Hráč přijímá zakázky od NPC, opravuje zařízení pomocí dílů a vylepšuje dílnu. Cílem je získat co nejvíce peněz a rozrůst podnik.
- **Technologie:** Godot 4 (GDScript), 2D pohled shora, pixel art.

## 2. GameDesign
- **Pravidla:**
  - Hráč pohybuje postavou po dílně (mřížka 8x8).
  - Zákazníci (NPC) nosí zařízení s poruchami (např. telefon: špatná baterie).
  - Opravné peníze: Telefon (50 peněz).
  - Vylepšení: Rychlost generování dílů (20s → 15s).
- **Příběh:** Hráč zdědí starou dílnu a musí ji zachránit před úpadkem.

## 3. Grafika
- **Software:** Pixelorama.
- **Hardware:** PC, myš.
- **Pravidla:** 16x16 px sprity, retro pixel art.
- **Návrhy:** Základní assety (postava, podlaha, zeď, okno) v [Interier](https://github.com/MasterkoCZ/it-repair-shop/tree/main/Graphics/Interier).
- **Assety:** [Assety](https://github.com/MasterkoCZ/it-repair-shop/tree/main/Graphics) – aktuálně postava a prostředí, telefony/počítače.

## 4. Zvuky
- **Software:** Audacity.
- **Hardware:** Mikrofon, PC.
- **Koncepce:** Realistické 8-bit zvuky (nástroje, sběr dílů, kroky).
- **Nahrávky:** Zatím hrubé zvuky kroků [game/assets/sounds/step.wav](game/assets/sounds/step.wav).
- **Assety:** Finální zvuky budou doladěny ve finální verzi.

## 5. Hudba
- **Software:** Žádný (půjčená hudba).
- **Hardware:** PC.
- **Koncepce:** 8-bit chiptune pro retro atmosféru, klidná v menu, rychlá ve hře. Hudba je NOCOPYRIGHT, stažena z internetu.
- **Nahrávky:** [game/assets/music/menu.mp3](game/assets/music/menu.mp3).
- **Assety:** Finální výběr později.

## 6. Implementace
- **Prototypy:**
  - Pohyb postavy: [game/prototypes/movement.tscn](game/prototypes/movement.tscn).
  - Přijímání zakázek: [game/prototypes/order_system.tscn](game/prototypes/order_system.tscn).
- **Hra:** Základní scéna [game/scenes/main.tscn](game/scenes/main.tscn), logika v [game/scripts/player.gd](game/scripts/player.gd).

## 7. Propagace
- **Koncepce:** Web s představením hry a screenshoty.
- **Materiály:**
  - Web: [web/index.html](web/index.html).
  - Banner: [web/banner.png](web/banner.png) – placeholder, finální verze později.
  - Video: Plánováno.

## 8. Finální hra
Aktuální verze obsahuje pohyb, základní UI (`partsList`) a systém zakázek.  
- **Screenshoty:** [web/screenshots/](web/screenshots/) – menu, dílna, HUD (připravuje se).
- **Build:**
  - Windows: [build/ITRepairShopTycoon.exe](build/ITRepairShopTycoon.exe).
  - HTML5: [build/html5/index.html](build/html5/index.html) – spustitelné na serveru.

## 9. Závěr
Největší výzvou bylo nastavení UI – `partsList` překrýval popisný `Label`, což jsem vyřešil přidáním `VBoxContainer`. Hra je zatím prototyp, ale mechaniky fungují. Chybí komplexní zařízení (počítače, notebooky) a finální hudba – plánuji dokončit do dalšího termínu.

---

**Odkaz na repozitář:** [https://github.com/MasterkoCZ/it-repair-shop](https://github.com/MasterkoCZ/it-repair-shop)  
**Autor:** Josef Razák  
**Licence:** Autorská práva © 2025, hudba NOCOPYRIGHT.
