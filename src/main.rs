use macroquad::audio::{load_sound_from_bytes, play_sound_once, Sound};
use macroquad::prelude::*;

const INK: Color = Color::new(0.10, 0.16, 0.29, 1.0);
const MUTED: Color = Color::new(0.35, 0.42, 0.54, 1.0);
const SKY: Color = Color::new(0.87, 0.95, 1.0, 1.0);
const BLUE: Color = Color::new(0.20, 0.40, 0.91, 1.0);
const PURPLE: Color = Color::new(0.47, 0.31, 0.84, 1.0);
const GREEN: Color = Color::new(0.13, 0.61, 0.40, 1.0);
const RED: Color = Color::new(0.82, 0.25, 0.30, 1.0);
const GOLD: Color = Color::new(1.0, 0.72, 0.20, 1.0);
const WHITE: Color = Color::new(1.0, 1.0, 1.0, 1.0);

#[derive(Clone, Copy, PartialEq)]
enum Subject { All, Maths, English, Science, Computing, Geography, History }

impl Subject {
    fn label(self) -> &'static str {
        match self { Self::All => "All subjects", Self::Maths => "Maths", Self::English => "English",
            Self::Science => "Science", Self::Computing => "Computing", Self::Geography => "Geography", Self::History => "History" }
    }
    fn color(self) -> Color {
        match self { Self::Maths => BLUE, Self::English => PURPLE, Self::Science => GREEN,
            Self::Computing => Color::new(0.04, 0.55, 0.65, 1.0), Self::Geography => Color::new(0.78, 0.48, 0.13, 1.0),
            Self::History => Color::new(0.75, 0.32, 0.48, 1.0), Self::All => BLUE }
    }
}

#[derive(Clone, Copy)]
struct Question {
    subject: Subject,
    prompt: &'static str,
    choices: [&'static str; 4],
    answer: usize,
    explanation: &'static str,
    hint: &'static str,
}

const QUESTIONS: [Question; 36] = [
    Question { subject: Subject::Maths, prompt: "What is 27 + 15?", choices: ["32", "42", "412", "40"], answer: 1, explanation: "27 + 10 = 37. Add 5 more to make 42.", hint: "Split 15 into 10 and 5." },
    Question { subject: Subject::Maths, prompt: "What is 63 - 28?", choices: ["45", "35", "41", "31"], answer: 1, explanation: "63 - 20 = 43, then take away 8 to make 35.", hint: "Take away 20 first, then 8." },
    Question { subject: Subject::Maths, prompt: "What is 5 × 2?", choices: ["7", "10", "12", "25"], answer: 1, explanation: "Five groups of two make ten.", hint: "Count 2, 4, 6, 8, 10." },
    Question { subject: Subject::Maths, prompt: "How many pence make £1?", choices: ["10p", "50p", "100p", "1000p"], answer: 2, explanation: "One pound is equal to 100 pence.", hint: "A pound coin is worth one hundred pence." },
    Question { subject: Subject::Maths, prompt: "Which number is even?", choices: ["17", "23", "36", "41"], answer: 2, explanation: "36 is even because it can be shared into pairs.", hint: "Even numbers end in 0, 2, 4, 6 or 8." },
    Question { subject: Subject::Maths, prompt: "What is double 14?", choices: ["18", "24", "28", "30"], answer: 2, explanation: "14 + 14 = 28.", hint: "Add the number to itself." },
    Question { subject: Subject::Maths, prompt: "Which is the largest number?", choices: ["309", "390", "903", "930"], answer: 3, explanation: "930 has 9 hundreds and 3 tens.", hint: "Compare the hundreds digits first." },
    Question { subject: Subject::Maths, prompt: "What time is half past 3?", choices: ["3:00", "3:15", "3:30", "4:30"], answer: 2, explanation: "Half past means 30 minutes after the hour.", hint: "The minute hand points to 6." },
    Question { subject: Subject::English, prompt: "Which word is an adjective?", choices: ["quickly", "jump", "bright", "under"], answer: 2, explanation: "Bright describes a noun, so it is an adjective.", hint: "An adjective describes a person, place or thing." },
    Question { subject: Subject::English, prompt: "Choose the correct past tense.", choices: ["I goed home.", "I went home.", "I going home.", "I goes home."], answer: 1, explanation: "Went is the past tense of go.", hint: "It is an unusual past-tense word." },
    Question { subject: Subject::English, prompt: "Which sentence needs a question mark?", choices: ["I like apples", "Where is my bag", "The sun is hot", "We ran home"], answer: 1, explanation: "A question asks something and ends with a question mark.", hint: "Which sentence is asking something?" },
    Question { subject: Subject::English, prompt: "Choose the correct spelling.", choices: ["because", "becos", "becuase", "becaus"], answer: 0, explanation: "Because is spelled b-e-c-a-u-s-e.", hint: "Say it slowly: be-cause." },
    Question { subject: Subject::English, prompt: "What is the plural of child?", choices: ["childs", "childes", "children", "childrens"], answer: 2, explanation: "The plural of child is children.", hint: "This word changes rather than adding just s." },
    Question { subject: Subject::English, prompt: "Which word is a verb?", choices: ["happily", "garden", "whisper", "yellow"], answer: 2, explanation: "Whisper is an action word, so it is a verb.", hint: "A verb can tell you what someone does." },
    Question { subject: Subject::Science, prompt: "What do most plants need to grow?", choices: ["Only darkness", "Water and light", "Plastic", "No air"], answer: 1, explanation: "Plants need light, water, air and room to grow.", hint: "Think about what a plant gets from the Sun and rain." },
    Question { subject: Subject::Science, prompt: "Which material is usually magnetic?", choices: ["Paper", "Glass", "Iron", "Wool"], answer: 2, explanation: "Iron is a magnetic material.", hint: "Magnets attract this metal." },
    Question { subject: Subject::Science, prompt: "Which animal is a mammal?", choices: ["Frog", "Dolphin", "Butterfly", "Trout"], answer: 1, explanation: "Dolphins are mammals and breathe air.", hint: "It lives in the sea but breathes air." },
    Question { subject: Subject::Science, prompt: "Which part of a plant takes in water?", choices: ["Flower", "Leaves", "Roots", "Fruit"], answer: 2, explanation: "Roots absorb water from the soil.", hint: "This part grows underground." },
    Question { subject: Subject::Science, prompt: "Which season is usually the coldest?", choices: ["Summer", "Spring", "Autumn", "Winter"], answer: 3, explanation: "Winter is usually the coldest season in the UK.", hint: "It often brings frost and sometimes snow." },
    Question { subject: Subject::Science, prompt: "Which is a healthy habit?", choices: ["Never sleeping", "Washing hands", "Eating only sweets", "Never moving"], answer: 1, explanation: "Washing hands helps remove germs and prevent illness.", hint: "What helps keep germs away?" },
    Question { subject: Subject::Computing, prompt: "What is an algorithm?", choices: ["A type of fruit", "A set of steps", "A screen colour", "A keyboard key"], answer: 1, explanation: "An algorithm is a set of instructions to complete a task.", hint: "Think of instructions for making a sandwich." },
    Question { subject: Subject::Computing, prompt: "What should you keep private online?", choices: ["Your password", "A favourite book", "A maths answer", "A cartoon"], answer: 0, explanation: "Never share passwords or private details with strangers.", hint: "It protects your account." },
    Question { subject: Subject::Computing, prompt: "What comes first in these instructions: stand, sit, clap?", choices: ["Clap", "Sit", "Stand", "Run"], answer: 2, explanation: "Following an algorithm means doing steps in order.", hint: "Read the first instruction carefully." },
    Question { subject: Subject::Computing, prompt: "Which device can move a pointer on screen?", choices: ["Mouse", "Speaker", "Printer paper", "Desk"], answer: 0, explanation: "A computer mouse moves the pointer on the screen.", hint: "It often has buttons and you move it by hand." },
    Question { subject: Subject::Geography, prompt: "Which city is in England?", choices: ["Birmingham", "Madrid", "Cairo", "Tokyo"], answer: 0, explanation: "Birmingham is a major city in the West Midlands, England.", hint: "It is a city in the West Midlands." },
    Question { subject: Subject::Geography, prompt: "Which is a human feature?", choices: ["River", "Mountain", "Bridge", "Valley"], answer: 2, explanation: "People build bridges; rivers and mountains are natural features.", hint: "People built it to cross over something." },
    Question { subject: Subject::Geography, prompt: "What is a map used for?", choices: ["Finding places", "Cooking food", "Washing clothes", "Growing seeds"], answer: 0, explanation: "Maps show places and help us find our way.", hint: "You might use one to plan a journey." },
    Question { subject: Subject::Geography, prompt: "Which direction is opposite north?", choices: ["East", "West", "South", "North-east"], answer: 2, explanation: "South is the opposite direction to north.", hint: "On most maps, it is at the bottom." },
    Question { subject: Subject::Geography, prompt: "Which is an island?", choices: ["Land surrounded by water", "A very tall hill", "A dry desert", "A deep forest"], answer: 0, explanation: "An island is land with water all around it.", hint: "Water surrounds it on every side." },
    Question { subject: Subject::History, prompt: "Which word describes something that happened before now?", choices: ["Future", "Past", "Tomorrow", "Next"], answer: 1, explanation: "The past is the time before the present.", hint: "Yesterday is part of this time." },
    Question { subject: Subject::History, prompt: "What can help us learn about the past?", choices: ["Old photographs", "A future plan", "A made-up guess only", "A blank page"], answer: 0, explanation: "Photographs can be historical sources that show people and places.", hint: "A picture taken long ago can be evidence." },
    Question { subject: Subject::History, prompt: "Who helps us learn about objects from the past?", choices: ["Archaeologist", "Pilot only", "Chef only", "Goalkeeper"], answer: 0, explanation: "Archaeologists study objects and remains from the past.", hint: "They may carefully dig to discover old objects." },
    Question { subject: Subject::History, prompt: "Which is the oldest way to send a message?", choices: ["Instant message app", "Email", "Handwritten letter", "Video call"], answer: 2, explanation: "People sent handwritten letters long before modern digital messages.", hint: "It is written on paper and sent to someone." },
    Question { subject: Subject::Maths, prompt: "There are 3 bags with 5 apples each. How many apples?", choices: ["8", "10", "15", "20"], answer: 2, explanation: "5 + 5 + 5 = 15 apples.", hint: "Add 5 three times." },
    Question { subject: Subject::English, prompt: "Choose the best joining word: I was tired ___ I went to bed.", choices: ["because", "but", "or", "under"], answer: 0, explanation: "Because explains why you went to bed.", hint: "This word gives a reason." },
    Question { subject: Subject::Science, prompt: "Which object is transparent?", choices: ["Brick wall", "Clear glass", "Wooden door", "Cardboard"], answer: 1, explanation: "Light passes through clear glass, so it is transparent.", hint: "You can see through it." },
];

#[derive(Clone, Copy, PartialEq)]
enum Screen { Home, Play, Results }

#[derive(Clone, Copy)]
struct UiButton { rect: Rect, label: &'static str, color: Color }

struct Game {
    screen: Screen,
    subject: Subject,
    question_order: Vec<usize>,
    order_pos: usize,
    selected: Option<usize>,
    submitted: bool,
    feedback: Option<bool>,
    show_hint: bool,
    correct: u32,
    attempts: u32,
    streak: u32,
    best_streak: u32,
    stars: u32,
    sound_on: bool,
    muted_label: &'static str,
}

impl Game {
    fn new() -> Self {
        Self { screen: Screen::Home, subject: Subject::All, question_order: Vec::new(), order_pos: 0,
            selected: None, submitted: false, feedback: None, show_hint: false, correct: 0,
            attempts: 0, streak: 0, best_streak: 0, stars: 0, sound_on: true, muted_label: "SOUND ON" }
    }
    fn current_question(&self) -> Question { QUESTIONS[self.question_order[self.order_pos]] }
    fn start(&mut self) {
        self.question_order = (0..QUESTIONS.len()).filter(|&i| self.subject == Subject::All || QUESTIONS[i].subject == self.subject).collect();
        if self.question_order.is_empty() { self.question_order = (0..QUESTIONS.len()).collect(); }
        self.order_pos = 0; self.selected = None; self.submitted = false; self.feedback = None; self.show_hint = false;
        self.correct = 0; self.attempts = 0; self.streak = 0; self.best_streak = 0; self.stars = 0; self.screen = Screen::Play;
    }
    fn submit(&mut self) -> Option<bool> {
        if self.submitted || self.selected.is_none() { return None; }
        let ok = self.selected == Some(self.current_question().answer);
        self.attempts += 1;
        if ok { self.correct += 1; self.stars += 1; self.streak += 1; self.best_streak = self.best_streak.max(self.streak); }
        else { self.streak = 0; }
        self.feedback = Some(ok); self.submitted = true; Some(ok)
    }
    fn next(&mut self) {
        if !self.submitted { return; }
        self.order_pos += 1;
        if self.order_pos >= self.question_order.len() { self.screen = Screen::Results; return; }
        self.selected = None; self.submitted = false; self.feedback = None; self.show_hint = false;
    }
}

fn round_box(r: Rect, fill: Color, radius: f32) {
    let rad = radius.min(r.h * 0.5).min(r.w * 0.5);
    draw_rectangle(r.x + rad, r.y, r.w - rad * 2.0, r.h, fill);
    draw_rectangle(r.x, r.y + rad, r.w, r.h - rad * 2.0, fill);
    draw_circle(r.x + rad, r.y + rad, rad, fill);
    draw_circle(r.x + r.w - rad, r.y + rad, rad, fill);
    draw_circle(r.x + rad, r.y + r.h - rad, rad, fill);
    draw_circle(r.x + r.w - rad, r.y + r.h - rad, rad, fill);
}
fn text_width(s: &str, size: f32) -> f32 { measure_text(s, None, size as u16, 1.0).width }
fn centered(s: &str, y: f32, size: f32, color: Color) { draw_text(s, (screen_width() - text_width(s, size)) * 0.5, y, size, color); }
fn label(s: &str, x: f32, y: f32, size: f32, color: Color) { draw_text(s, x, y, size, color); }
fn button(r: Rect, text: &str, fill: Color, selected: bool) -> bool {
    let (mx, my) = mouse_position();
    let hover = r.contains(vec2(mx, my));
    round_box(Rect::new(r.x, r.y + 3.0, r.w, r.h), Color::new(0.06, 0.10, 0.20, 0.10), 12.0);
    round_box(r, if hover { Color::new((fill.r + 0.06).min(1.0), (fill.g + 0.06).min(1.0), (fill.b + 0.06).min(1.0), 1.0) } else { fill }, 12.0);
    if selected { draw_rectangle_lines(r.x + 1.0, r.y + 1.0, r.w - 2.0, r.h - 2.0, 3.0, BLUE); }
    let size = if text.len() > 28 { 15.0 } else if text.len() > 19 { 17.0 } else { 19.0 };
    let tw = text_width(text, size);
    label(text, r.x + (r.w - tw) * 0.5, r.y + r.h * 0.5 + size * 0.34, size, INK);
    hover && is_mouse_button_pressed(MouseButton::Left)
}
fn card(r: Rect, color: Color) { round_box(Rect::new(r.x, r.y + 5.0, r.w, r.h), Color::new(0.07, 0.13, 0.22, 0.10), 18.0); round_box(r, color, 18.0); }
fn fit_text(s: &str, max_width: f32, size: f32) -> String {
    if text_width(s, size) <= max_width { return s.to_string(); }
    let mut out = String::new();
    for word in s.split_whitespace() {
        let next = if out.is_empty() { word.to_string() } else { format!("{} {}", out, word) };
        if text_width(&next, size) > max_width { break; }
        out = next;
    }
    if out.is_empty() { s.chars().take(20).collect() } else { out }
}
fn draw_mascot(x: f32, y: f32, scale: f32, wave: bool) {
    // A friendly little explorer made from crisp vector shapes.
    draw_circle(x, y + 3.0 * scale, 34.0 * scale, Color::new(0.10, 0.20, 0.36, 0.12));
    draw_ellipse(x, y + 12.0 * scale, 25.0 * scale, 29.0 * scale, BLUE);
    draw_circle(x, y - 16.0 * scale, 25.0 * scale, Color::new(1.0, 0.78, 0.60, 1.0));
    draw_arc(x, y - 18.0 * scale, 25.0 * scale, 0.0, 180.0, 1.0, 8.0 * scale, Color::new(0.25, 0.16, 0.12, 1.0));
    draw_circle(x - 8.0 * scale, y - 17.0 * scale, 2.8 * scale, INK);
    draw_circle(x + 8.0 * scale, y - 17.0 * scale, 2.8 * scale, INK);
    draw_arc(x, y - 10.0 * scale, 8.0 * scale, 200.0, 340.0, 1.0, 2.0 * scale, RED);
    draw_circle(x, y - 42.0 * scale, 24.0 * scale, PURPLE);
    draw_triangle(vec2(x - 18.0 * scale, y - 53.0 * scale), vec2(x + 18.0 * scale, y - 53.0 * scale), vec2(x, y - 68.0 * scale), GOLD);
    draw_circle(x + 22.0 * scale, y + 7.0 * scale, 8.0 * scale, Color::new(1.0, 0.78, 0.60, 1.0));
    if wave { draw_line(x + 22.0 * scale, y + 6.0 * scale, x + 35.0 * scale, y - 5.0 * scale, 5.0 * scale, BLUE); }
}
fn draw_background() {
    clear_background(SKY);
    let w = screen_width(); let h = screen_height();
    draw_circle(w * 0.88, h * 0.14, h * 0.055, GOLD);
    draw_circle(w * 0.14, h * 0.13, h * 0.035, WHITE);
    draw_circle(w * 0.17, h * 0.12, h * 0.045, WHITE);
    draw_circle(w * 0.20, h * 0.14, h * 0.03, WHITE);
    draw_circle(w * 0.69, h * 0.09, h * 0.026, WHITE);
    draw_circle(w * 0.72, h * 0.08, h * 0.034, WHITE);
    draw_circle(w * 0.75, h * 0.10, h * 0.025, WHITE);
    draw_rectangle(0.0, h * 0.72, w, h * 0.28, Color::new(0.66, 0.87, 0.60, 1.0));
    draw_circle(w * 0.04, h * 0.78, h * 0.11, Color::new(0.54, 0.79, 0.50, 1.0));
    draw_circle(w * 0.94, h * 0.78, h * 0.13, Color::new(0.54, 0.79, 0.50, 1.0));
}
fn wav_tone(freq: f32, duration: f32) -> Vec<u8> {
    let rate: u32 = 22050;
    let samples = (rate as f32 * duration) as u32;
    let mut bytes = Vec::with_capacity(44 + samples as usize * 2);
    bytes.extend_from_slice(b"RIFF"); bytes.extend_from_slice(&(36 + samples * 2).to_le_bytes());
    bytes.extend_from_slice(b"WAVEfmt "); bytes.extend_from_slice(&16u32.to_le_bytes());
    bytes.extend_from_slice(&1u16.to_le_bytes()); bytes.extend_from_slice(&1u16.to_le_bytes());
    bytes.extend_from_slice(&rate.to_le_bytes()); bytes.extend_from_slice(&(rate * 2).to_le_bytes());
    bytes.extend_from_slice(&2u16.to_le_bytes()); bytes.extend_from_slice(&16u16.to_le_bytes());
    bytes.extend_from_slice(b"data"); bytes.extend_from_slice(&(samples * 2).to_le_bytes());
    for i in 0..samples {
        let t = i as f32 / rate as f32;
        let fade = (1.0 - t / duration).clamp(0.0, 1.0);
        let v = ( (t * freq * std::f32::consts::TAU).sin() * fade * 0.22 * i16::MAX as f32) as i16;
        bytes.extend_from_slice(&v.to_le_bytes());
    }
    bytes
}
fn draw_top_bar(title: &str, sub: &str, sound_on: bool) -> bool {
    let w = screen_width();
    round_box(Rect::new(18.0, 12.0, w - 36.0, 54.0), WHITE, 16.0);
    draw_circle(47.0, 39.0, 17.0, BLUE);
    label("★", 37.0, 45.0, 21.0, GOLD);
    label(title, 75.0, 35.0, 20.0, INK);
    label(sub, 75.0, 53.0, 12.0, MUTED);
    button(Rect::new(w - 150.0, 22.0, 118.0, 34.0), if sound_on { "♫ SOUND ON" } else { "♫ SOUND OFF" }, Color::new(0.91, 0.94, 1.0, 1.0), false)
}

#[macroquad::main("Year 2 Adventure Academy")]
async fn main() {
    let success_sound: Sound = load_sound_from_bytes(&wav_tone(880.0, 0.16)).await;
    let wrong_sound: Sound = load_sound_from_bytes(&wav_tone(220.0, 0.20)).await;
    let tap_sound: Sound = load_sound_from_bytes(&wav_tone(540.0, 0.07)).await;
    let mut game = Game::new();
    loop {
        let w = screen_width(); let h = screen_height();
        draw_background();
        match game.screen {
            Screen::Home => {
                let sound_clicked = draw_top_bar("ADVENTURE ACADEMY", "YEAR 2 • LEARN BY EXPLORING", game.sound_on);
                if sound_clicked { game.sound_on = !game.sound_on; if game.sound_on { play_sound_once(&tap_sound); } }
                let left = Rect::new(w * 0.06, h * 0.20, w * 0.54, h * 0.66);
                card(left, WHITE);
                label("READY, EXPLORER?", left.x + 28.0, left.y + 42.0, 15.0, PURPLE);
                label("Your next big adventure", left.x + 28.0, left.y + 83.0, 29.0, INK);
                label("Solve puzzles, collect stars and unlock", left.x + 28.0, left.y + 116.0, 17.0, MUTED);
                label("new places as you learn!", left.x + 28.0, left.y + 139.0, 17.0, MUTED);
                let subjects = [Subject::All, Subject::Maths, Subject::English, Subject::Science, Subject::Computing, Subject::Geography, Subject::History];
                label("CHOOSE YOUR ADVENTURE", left.x + 28.0, left.y + 180.0, 14.0, INK);
                let bw = (left.w - 56.0 - 18.0) / 3.0;
                for i in 0..subjects.len() {
                    let row = i / 3; let col = i % 3;
                    let r = Rect::new(left.x + 28.0 + col as f32 * (bw + 9.0), left.y + 196.0 + row as f32 * 43.0, bw, 34.0);
                    let s = subjects[i];
                    let fill = if game.subject == s { s.color() } else { Color::new(0.92, 0.95, 0.99, 1.0) };
                    if button(r, s.label(), fill, game.subject == s) { game.subject = s; if game.sound_on { play_sound_once(&tap_sound); } }
                    if game.subject == s && s != Subject::All {
                        draw_circle(r.x + r.w - 10.0, r.y + 7.0, 3.0, GOLD);
                    }
                }
                let play = Rect::new(left.x + 28.0, left.y + left.h - 57.0, left.w - 56.0, 42.0);
                if button(play, "▶  START MY ADVENTURE", Color::new(0.53, 0.88, 0.63, 1.0), false) {
                    game.start(); if game.sound_on { play_sound_once(&tap_sound); }
                }
                let right = Rect::new(w * 0.64, h * 0.23, w * 0.30, h * 0.60);
                card(right, Color::new(0.97, 0.98, 1.0, 1.0));
                draw_mascot(right.x + right.w * 0.5, right.y + right.h * 0.38, (h / 480.0).clamp(0.70, 1.0), true);
                centered("Meet Scout!", right.y + right.h * 0.68, 23.0, PURPLE);
                centered("Your learning buddy", right.y + right.h * 0.76, 15.0, MUTED);
                centered("36 mini challenges to explore", right.y + right.h * 0.84, 13.0, INK);
                label("Tap a subject, then start. You can retry any question and use hints.", 26.0, h - 13.0, 12.0, INK);
            }
            Screen::Play => {
                let sound_clicked = draw_top_bar("ADVENTURE IN PROGRESS", game.current_question().subject.label(), game.sound_on);
                if sound_clicked { game.sound_on = !game.sound_on; if game.sound_on { play_sound_once(&tap_sound); } }
                let q = game.current_question();
                let progress = game.order_pos as f32 / game.question_order.len() as f32;
                let px = 24.0; let py = 80.0; let pw = w - 48.0;
                round_box(Rect::new(px, py, pw, 8.0), Color::new(0.77, 0.83, 0.91, 1.0), 4.0);
                round_box(Rect::new(px, py, pw * progress.max(0.02), 8.0), GREEN, 4.0);
                let left = Rect::new(24.0, 101.0, w * 0.44 - 28.0, h - 171.0);
                let right = Rect::new(w * 0.46, 101.0, w * 0.54 - 28.0, h - 171.0);
                card(left, WHITE); card(right, WHITE);
                round_box(Rect::new(left.x + 18.0, left.y + 16.0, 110.0, 26.0), q.subject.color(), 10.0);
                label(q.subject.label(), left.x + 28.0, left.y + 34.0, 13.0, WHITE);
                label(&format!("CHALLENGE {:02}", game.order_pos + 1), left.x + left.w - 135.0, left.y + 34.0, 12.0, MUTED);
                let prompt_size = if text_width(q.prompt, 26.0) > left.w - 42.0 { 21.0 } else { 26.0 };
                label(&fit_text(q.prompt, left.w - 38.0, prompt_size), left.x + 20.0, left.y + 82.0, prompt_size, INK);
                draw_mascot(left.x + left.w * 0.75, left.y + left.h * 0.67, (h / 520.0).clamp(0.48, 0.72), game.feedback == Some(true));
                label(if game.feedback == Some(true) { "Brilliant work!" } else if game.feedback == Some(false) { "Keep trying!" } else { "Think it through…" },
                    left.x + 20.0, left.y + left.h - 38.0, 17.0, game.feedback.map(|ok| if ok { GREEN } else { RED }).unwrap_or(PURPLE));
                label(&format!("⭐ {}    🔥 {}", game.stars, game.streak), left.x + 20.0, left.y + left.h - 15.0, 13.0, MUTED);
                label("PICK YOUR ANSWER", right.x + 20.0, right.y + 29.0, 14.0, MUTED);
                let gap = 10.0; let margin = 18.0;
                let bw = (right.w - margin * 2.0 - gap) / 2.0;
                let bh = ((right.h - 90.0 - gap) / 2.0).min(66.0);
                for i in 0..4 {
                    let r = Rect::new(right.x + margin + (i % 2) as f32 * (bw + gap), right.y + 43.0 + (i / 2) as f32 * (bh + gap), bw, bh);
                    let fill = if game.submitted && i == q.answer { Color::new(0.77, 0.94, 0.80, 1.0) }
                        else if game.submitted && game.selected == Some(i) && i != q.answer { Color::new(1.0, 0.83, 0.84, 1.0) }
                        else if game.selected == Some(i) { Color::new(0.80, 0.86, 1.0, 1.0) }
                        else { Color::new(0.94, 0.96, 1.0, 1.0) };
                    if !game.submitted && button(r, &format!("{}   {}", ["A", "B", "C", "D"][i], q.choices[i]), fill, game.selected == Some(i)) {
                        game.selected = Some(i); if game.sound_on { play_sound_once(&tap_sound); }
                    } else if game.submitted {
                        button(r, &format!("{}   {}", ["A", "B", "C", "D"][i], q.choices[i]), fill, game.selected == Some(i));
                    }
                }
                let hint_r = Rect::new(right.x + 18.0, right.y + right.h - 38.0, 100.0, 28.0);
                if !game.submitted && button(hint_r, if game.show_hint { "HINT SHOWN" } else { "💡 HINT" }, Color::new(1.0, 0.94, 0.73, 1.0), game.show_hint) {
                    game.show_hint = true; if game.sound_on { play_sound_once(&tap_sound); }
                }
                let action_r = Rect::new(right.x + right.w - 176.0, right.y + right.h - 43.0, 158.0, 34.0);
                if game.submitted {
                    if button(action_r, if game.order_pos + 1 == game.question_order.len() { "SEE MY SCORE  →" } else { "NEXT QUESTION  →" }, Color::new(0.54, 0.88, 0.63, 1.0), false) {
                        game.next(); if game.sound_on { play_sound_once(&tap_sound); }
                    }
                } else if button(action_r, "CHECK ANSWER  ✓", if game.selected.is_some() { Color::new(0.54, 0.88, 0.63, 1.0) } else { Color::new(0.86, 0.89, 0.93, 1.0) }, false) {
                    if let Some(ok) = game.submit() { if game.sound_on { play_sound_once(if ok { &success_sound } else { &wrong_sound }); } }
                }
                if game.show_hint && !game.submitted {
                    round_box(Rect::new(right.x + 124.0, right.y + right.h - 39.0, (right.w - 318.0).max(80.0), 30.0), Color::new(1.0, 0.97, 0.86, 1.0), 8.0);
                    label(&fit_text(q.hint, (right.w - 336.0).max(70.0), 12.0), right.x + 132.0, right.y + right.h - 20.0, 12.0, INK);
                }
                if let Some(ok) = game.feedback {
                    let feedback_y = right.y + right.h - 61.0;
                    label(&fit_text(if ok { q.explanation } else { "Not quite. The correct answer is highlighted above." }, right.w - 36.0, 13.0), right.x + 18.0, feedback_y, 13.0, if ok { GREEN } else { RED });
                } else if game.show_hint {
                    // Keep the hint in the answer card without covering the choices.
                }
                let home = Rect::new(24.0, h - 54.0, 95.0, 34.0);
                if button(home, "← HOME", Color::new(0.91, 0.94, 0.98, 1.0), false) { game.screen = Screen::Home; if game.sound_on { play_sound_once(&tap_sound); } }
                label(&format!("Question {} of {}     •     Correct {}", game.order_pos + 1, game.question_order.len(), game.correct), 142.0, h - 31.0, 13.0, INK);
            }
            Screen::Results => {
                let sound_clicked = draw_top_bar("ADVENTURE COMPLETE!", "YOU DID IT, EXPLORER!", game.sound_on);
                if sound_clicked { game.sound_on = !game.sound_on; }
                let panel = Rect::new(w * 0.13, h * 0.18, w * 0.74, h * 0.69);
                card(panel, WHITE);
                draw_mascot(w * 0.28, h * 0.48, (h / 460.0).clamp(0.72, 1.0), true);
                label("YOU ARE A SUPER STAR!", w * 0.40, h * 0.34, 26.0, PURPLE);
                label(&format!("You got {} out of {} correct", game.correct, game.question_order.len()), w * 0.40, h * 0.43, 21.0, INK);
                let pct = if game.question_order.is_empty() { 0 } else { (game.correct * 100 / game.question_order.len() as u32) };
                label(&format!("Score: {}%     Stars earned: {}     Best streak: {}", pct, game.stars, game.best_streak), w * 0.40, h * 0.51, 16.0, MUTED);
                label(if pct >= 80 { "Amazing! You are ready for a new challenge." } else if pct >= 50 { "Great effort! Practise again to grow your skills." } else { "Every try helps you learn. Have another go!" }, w * 0.40, h * 0.59, 15.0, GREEN);
                let again = Rect::new(w * 0.40, h * 0.68, w * 0.22, 42.0);
                let home = Rect::new(w * 0.64, h * 0.68, w * 0.16, 42.0);
                if button(again, "PLAY AGAIN  ↻", Color::new(0.54, 0.88, 0.63, 1.0), false) { game.start(); if game.sound_on { play_sound_once(&success_sound); } }
                if button(home, "HOME", Color::new(0.91, 0.94, 0.98, 1.0), false) { game.screen = Screen::Home; }
            }
        }
        if is_key_pressed(KeyCode::Escape) && game.screen != Screen::Home { game.screen = Screen::Home; }
        next_frame().await;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn game_has_a_wide_question_bank() { assert!(QUESTIONS.len() >= 30); }
    #[test] fn each_question_has_a_valid_answer() { for q in QUESTIONS { assert!(q.answer < q.choices.len()); } }
    #[test] fn subject_filters_have_questions() { for s in [Subject::Maths, Subject::English, Subject::Science, Subject::Computing, Subject::Geography, Subject::History] { assert!(QUESTIONS.iter().any(|q| q.subject == s)); } }
    #[test] fn selected_answer_is_required() { let mut g = Game::new(); g.start(); assert_eq!(g.submit(), None); assert_eq!(g.attempts, 0); }
    #[test] fn correct_answer_scores_once() { let mut g = Game::new(); g.start(); g.selected = Some(g.current_question().answer); assert_eq!(g.submit(), Some(true)); assert_eq!(g.correct, 1); assert_eq!(g.stars, 1); assert_eq!(g.submit(), None); }
    #[test] fn wrong_answer_does_not_increase_score() { let mut g = Game::new(); g.start(); let a = g.current_question().answer; g.selected = Some((a + 1) % 4); assert_eq!(g.submit(), Some(false)); assert_eq!(g.correct, 0); assert_eq!(g.attempts, 1); }
    #[test] fn next_advances_and_finishes() { let mut g = Game::new(); g.start(); let total = g.question_order.len(); for _ in 0..total { g.selected = Some(g.current_question().answer); g.submit(); g.next(); } assert_eq!(g.screen, Screen::Results); }
    #[test] fn sound_setting_starts_enabled() { let g = Game::new(); assert!(g.sound_on); }
}
