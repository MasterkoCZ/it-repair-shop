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
- **Koncepce:** Realistické zvuky (nástroje, kroky).
- **Assety:** [Assety](https://github.com/MasterkoCZ/it-repair-shop/tree/main/Audio)

## 5. Hudba
- **Software:** Žádný (půjčená hudba).
- **Hardware:** PC.
- **Koncepce:** 8-bit chiptune pro retro atmosféru, klidná v menu, rychlá ve hře. Hudba je NOCOPYRIGHT, stažena z internetu.
- **Assety:** [Assety](https://github.com/MasterkoCZ/it-repair-shop/tree/main/Audio)

## 6. Implementace
- **Prototypy:**
  - Pohyb postavy: ![Pohyb](https://github.com/MasterkoCZ/it-repair-shop/blob/main/obr%C3%A1zky/pohyb.png).
  - Vytvoření NPC: ![NPC](https://github.com/MasterkoCZ/it-repair-shop/blob/main/obr%C3%A1zky/npc.png).
- **Hra:** Základní scéna [game](https://github.com/MasterkoCZ/it-repair-shop/blob/main/Scenes/game.tscn)

## 7. Propagace
- **Koncepce:** Web s představením hry a screenshoty.
- **Materiály:**
  - Web: [Web](https://github.com/MasterkoCZ/it-repair-shop/tree/main/Website).

## 8. Finální hra
Aktuální verze obsahuje pohyb, základní UI (`partsList`) a systém zakázek.  
- **Screenshoty:** [web/screenshots/](web/screenshots/) – menu, dílna, HUD (připravuje se).
- **Build:**
  - Windows: Prozatím na OneDrive (brzo na githubu) [ITRepairShopTycoon.exe](https://vosassvarnsdorf-my.sharepoint.com/:u:/g/personal/josef_razak021_skolavdf_cz/EdKVHHEbsONBv_71QOpC-IoB--15424hxHRmp6qlpqolng?e=nfv8Id).
## Ovládání
- **Pohyb** WASD nebo šipky
- **Interakce** E (sběr, odevzdávání), F (upgrade), I (inventář), Levé tlačítko myši (kliknutím na item v inventáři (u opravářského stolu) se začne opravovat))

## 9. Závěr
Největší výzvou při vývoji "IT Repair Shop Tycoon" bylo nastavování celého průběhu itemů a inventáře – konkrétně jak spravovat sbírání dílů z generátorů, jejich ukládání a použití při opravách na stole. Zpočátku jsem měl problém s tím, že se rozbité a opravené itemy v `player_inventory` špatně trackovaly a UI (`InventoryList`, `PartsList`) je nezobrazovalo přehledně, což působilo zmatek. Vyřešil jsem to použitím dvou systémů: `player_inventory` jako pole pro rozbité a opravené itemy (např. `mobile_screen_bad`, `repaired_mobile_screen`) a `repair_parts` jako `Dictionary` pro počet dílů (např. `new_screen: 2`), s dynamickou aktualizací UI přes `update_inventory_ui()` a `update_parts_ui()`. Hra je funkční prototyp s pohybem, opravami a levelovým systémem, ale chybí ještě rozšíření zařízení (např. notebooky), což plánuji dokončit.

**Odkaz na repozitář:** [repozitář](https://github.com/MasterkoCZ/it-repair-shop)  
**Autor:** Josef Razák  
**Licence:** Autorská práva © 2025, hudba NOCOPYRIGHT.
