from __future__ import annotations

import random
from pathlib import Path
from typing import Tuple

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "scenes" / "home_perch"
OUT.mkdir(parents=True, exist_ok=True)


def noise_texture(width: int, height: int, base: Tuple[int, int, int], variation: int = 30) -> Image.Image:
    image = Image.new("RGB", (width, height), base)
    pixels = image.load()
    for y in range(height):
        for x in range(width):
            delta = random.randint(-variation, variation)
            pixels[x, y] = tuple(max(0, min(255, channel + delta)) for channel in base)
    return image.filter(ImageFilter.GaussianBlur(0.6))


def add_shadow(canvas: Image.Image, box: Tuple[int, int, int, int], radius: int = 24, opacity: int = 90, offset: Tuple[int, int] = (10, 14)) -> None:
    x0, y0, x1, y1 = box
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(shadow)
    draw.rounded_rectangle((x0 + offset[0], y0 + offset[1], x1 + offset[0], y1 + offset[1]), radius=radius, fill=(0, 0, 0, opacity))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius / 1.2))
    canvas.alpha_composite(shadow)


def save_webp(image: Image.Image, filename: str, quality: int = 82) -> None:
    path = OUT / filename
    image.convert("RGB").save(path, "WEBP", quality=quality, method=6)
    print(f"wrote {path.relative_to(ROOT)}")


def make_background() -> None:
    width, height = 1280, 720
    image = Image.new("RGBA", (width, height), (0, 0, 0, 255))
    draw = ImageDraw.Draw(image)

    for y in range(height):
        t = y / height
        draw.line((0, y, width, y), fill=(int(42 + 50 * t), int(25 + 35 * t), int(14 + 25 * t), 255))

    draw.rounded_rectangle((770, 45, 1195, 310), radius=18, fill=(52, 70, 58, 255), outline=(70, 42, 24, 255), width=12)
    for y in range(60, 300):
        t = (y - 60) / 240
        draw.line((785, y, 1180, y), fill=(int(143 - 45 * t), int(178 - 35 * t), int(158 - 45 * t), 255))

    for _ in range(44):
        x = random.randint(790, 1180)
        tree_height = random.randint(80, 210)
        base_y = 310
        draw.line((x, base_y, x - random.randint(0, 15), base_y - tree_height), fill=(36, 73, 45, 185), width=random.randint(2, 5))
        for j in range(6):
            y = base_y - tree_height + j * 18 + random.randint(-5, 5)
            draw.ellipse((x - 35, y - 18, x + 35, y + 24), fill=(27, 82 + random.randint(-10, 20), 44, 135))

    for i in range(8):
        y = 250 + i * 7
        draw.arc((830, y, 1200, y + 80), 180, 360, fill=(94, 145, 154, 145), width=3)

    desk = noise_texture(width, 380, (119, 69, 35), 45).convert("RGBA")
    desk_draw = ImageDraw.Draw(desk)
    for _ in range(70):
        y = random.randint(0, 379)
        desk_draw.line((random.randint(-100, 100), y, width + random.randint(-100, 100), y + random.randint(-20, 20)), fill=(80, 42, 22, 78), width=random.randint(1, 3))
    image.alpha_composite(desk, (0, 340))

    light = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    light_draw = ImageDraw.Draw(light)
    for i in range(4):
        x = 300 + i * 130
        light_draw.polygon([(x, 0), (x + 150, 0), (x - 240, height), (x - 380, height)], fill=(255, 222, 150, 25))
    image.alpha_composite(light)

    add_shadow(image, (70, 410, 210, 550), 45, 80, (12, 16))
    draw.ellipse((70, 410, 210, 550), fill=(230, 214, 187, 255), outline=(180, 150, 120, 255), width=5)
    draw.ellipse((105, 445, 175, 515), fill=(37, 23, 15, 255))
    draw.arc((190, 445, 245, 515), -70, 70, fill=(220, 205, 180, 255), width=10)
    draw.rounded_rectangle((160, 620, 430, 636), radius=8, fill=(22, 25, 30, 255))
    draw.rounded_rectangle((390, 620, 450, 636), radius=8, fill=(170, 140, 90, 255))

    save_webp(image, "background_cabin_desk.webp", 78)


def make_notebook() -> None:
    width, height = 760, 520
    image = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    add_shadow(image, (20, 35, width - 25, height - 30), 28, 95, (16, 20))
    draw.rounded_rectangle((20, 35, width - 25, height - 30), radius=26, fill=(96, 65, 42, 255))
    draw.rounded_rectangle((55, 48, width - 38, height - 45), radius=18, fill=(242, 233, 213, 255))
    for y in range(75, height - 60, 28):
        draw.line((70, y, width - 55, y), fill=(80, 100, 120, 38), width=1)
    draw.line((110, 55, 110, height - 50), fill=(190, 80, 70, 55), width=2)
    for y in range(80, height - 70, 42):
        draw.ellipse((77, y, 91, y + 14), fill=(110, 80, 55, 120))
    save_webp(image, "notebook_open_blank.webp", 86)


def make_envelope() -> None:
    width, height = 430, 390
    image = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    add_shadow(image, (40, 90, width - 25, height - 25), 18, 90, (13, 20))
    for i, (x, y, color) in enumerate([(76, 15, (221, 224, 190)), (55, 38, (210, 218, 183)), (90, 62, (225, 225, 194))]):
        draw.rounded_rectangle((x, y, width - 45 + i * 4, y + 74), radius=8, fill=color + (255,), outline=(97, 130, 80, 120), width=2)
    draw.rounded_rectangle((40, 92, width - 25, height - 25), radius=16, fill=(188, 150, 86, 255))
    draw.polygon([(40, 92), (width // 2, 235), (width - 25, 92)], fill=(205, 170, 105, 255))
    draw.line((40, 92, width // 2, 235, width - 25, 92), fill=(140, 105, 65, 150), width=2)
    save_webp(image, "envelope_cash_blank.webp", 88)


def make_sticky() -> None:
    width, height = 300, 245
    image = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    add_shadow(image, (18, 26, width - 20, height - 18), 10, 80, (8, 14))
    draw.rounded_rectangle((18, 26, width - 20, height - 18), radius=8, fill=(226, 203, 83, 255))
    draw.polygon([(width - 75, height - 18), (width - 20, height - 18), (width - 20, height - 65)], fill=(190, 170, 65, 180))
    draw.ellipse((width // 2 - 12, 10, width // 2 + 12, 34), fill=(170, 105, 45, 255))
    save_webp(image, "sticky_note_blank.webp", 90)


def main() -> None:
    random.seed(404)
    make_background()
    make_notebook()
    make_envelope()
    make_sticky()
    print("\nHome Perch art pack generated.")


if __name__ == "__main__":
    main()
