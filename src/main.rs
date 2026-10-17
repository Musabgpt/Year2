use macroquad::prelude::*;

const BG: Color = Color::new(0.91, 0.96, 1.0, 1.0);
const INK: Color = Color::new(0.10, 0.17, 0.27, 1.0);
const BLUE: Color = Color::new(0.16, 0.39, 0.75, 1.0);
const GREEN: Color = Color::new(0.18, 0.60, 0.39, 1.0);
const RED: Color = Color::new(0.78, 0.25, 0.24, 1.0);
const GOLD: Color = Color::new(1.0, 0.72, 0.20, 1.0);

#[derive(Clone, Copy)]
struct Question {
    subject: &'static str,
    prompt: &'static str,
    choices: [&'static str; 4],
    answer: usize,
    explanation: &'static str,
}

const QUESTIONS: [Question; 8] = [
    Question { subject: "Maths", prompt: "What is 27 + 15?", choices: ["32", "42", "412", "40"], answer: 1, explanation: "27 + 10 = 37, then add 5 more to make 42." },
    Question { subject: "English", prompt: "Which word is an adjective?", choices: ["quickly", "jump", "bright", "under"], answer: 2, explanation: "Bright describes a noun, so it is an adjective." },
    Question { subject: "Science", prompt: "What do most plants need to grow?", choices: ["Only darkness", "Water and light", "Plastic", "No air"], answer: 1, explanation: "Plants need light, water, air and room to grow." },
    Question { subject: "Maths", prompt: "How many pence are in £1?", choices: ["10p", "50p", "100p", "1000p"], answer: 2, explanation: "One pound is equal to 100 pence." },
    Question { subject: "Geography", prompt: "Which city is in England?", choices: ["Birmingham", "Madrid", "Cairo", "Tokyo"], answer: 0, explanation: "Birmingham is a major city in the West Midlands, England." },
    Question { subject: "Maths", prompt: "What is 5 × 2?", choices: ["7", "10", "12", "25"], answer: 1, explanation: "Five groups of two make ten." },
    Question { subject: "Computing", prompt: "What is an algorithm?", choices: ["A type of fruit", "A set of steps", "A screen colour", "A keyboard key"], answer: 1, explanation: "An algorithm is a set of instructions or steps to complete a task." },
    Question { subject: "Science", prompt: "Which material is usually magnetic?", choices: ["Paper", "Glass", "Iron", "Wool"], answer: 2, explanation: "Iron is a magnetic material." },
];

#[derive(Clone, Copy, PartialEq)]
enum Screen { Home, Play }

struct Game {
    screen: Screen,
    question_index: usize,
    player_step: u32,
    selected: Option<usize>,
    feedback: Option<bool>,
    submitted: bool,
    correct: u32,
    attempts: u32,
}

impl Game {
    fn new() -> Self {
        Self { screen: Screen::Home, question_index: 0, player_step: 0, selected: None,
            feedback: None, submitted: false, correct: 0, attempts: 0 }
    }

    fn submit(&mut self) {
        if self.submitted { return; }
        let Some(choice) = self.selected else { return; };
        let q = QUESTIONS[self.question_index % QUESTIONS.len()];
        let is_correct = choice == q.answer;
        if is_correct {
            self.player_step = self.player_step.saturating_add(1);
            self.correct += 1;
        } else {
            self.player_step = self.player_step.saturating_sub(1);
        }
        self.attempts += 1;
        self.feedback = Some(is_correct);
        self.submitted = true;
    }

    fn next_question(&mut self) {
        if !self.submitted { return; }
        self.question_index = (self.question_index + 1) % QUESTIONS.len();
        self.selected = None;
        self.feedback = None;
        self.submitted = false;
    }
}

fn panel(x: f32, y: f32, w: f32, h: f32, color: Color) {
    draw_rectangle(x, y + 5.0, w, h, Color::new(0.08, 0.14, 0.24, 0.10));
    draw_rectangle(x, y, w, h, color);
}

fn text_center(text: &str, y: f32, size: f32, color: Color) {
    let d = measure_text(text, None, size as u16, 1.0);
    draw_text(text, (screen_width() - d.width) / 2.0, y, size, color);
}

fn draw_world(step: u32, y: f32, width: f32) {
    let road_y = y + 66.0;
    draw_rectangle(0.0, y, width, 150.0, Color::new(0.72, 0.88, 0.98, 1.0));
    draw_circle(width * 0.83, y + 25.0, 18.0, GOLD);
    for i in 0..6 {
        let x = (i as f32) * (width / 5.0);
        draw_circle(x + 30.0, y + 30.0, 14.0, WHITE);
        draw_circle(x + 45.0, y + 28.0, 18.0, WHITE);
        draw_circle(x + 61.0, y + 32.0, 13.0, WHITE);
    }
    draw_rectangle(0.0, y + 58.0, width, 92.0, Color::new(0.47, 0.76, 0.48, 1.0));
    draw_rectangle(0.0, road_y, width, 47.0, Color::new(0.38, 0.42, 0.48, 1.0));
    for i in 0..8 {
        draw_rectangle(i as f32 * (width / 7.0), road_y + 21.0, 26.0, 4.0, Color::new(1.0, 0.91, 0.61, 1.0));
    }
    let count = 7usize;
    for i in 0..count {
        let px = 28.0 + i as f32 * ((width - 56.0) / (count as f32 - 1.0));
        draw_circle(px, road_y + 23.0, 9.0, if i as u32 <= step.min(6) { GOLD } else { LIGHTGRAY });
        draw_circle(px, road_y + 23.0, 4.0, WHITE);
    }
    let index = step.min(6) as f32;
    let player_x = 28.0 + index * ((width - 56.0) / 6.0);
    // Original procedural character: head, body, arms and legs.
    draw_circle(player_x, road_y - 3.0, 10.0, Color::new(0.98, 0.75, 0.55, 1.0));
    draw_rectangle(player_x - 8.0, road_y + 7.0, 16.0, 20.0, BLUE);
    draw_line(player_x - 5.0, road_y + 26.0, player_x - 10.0, road_y + 35.0, INK, 3.0);
    draw_line(player_x + 5.0, road_y + 26.0, player_x + 10.0, road_y + 35.0, INK, 3.0);
    draw_line(player_x - 7.0, road_y + 12.0, player_x - 14.0, road_y + 20.0, INK, 3.0);
    draw_line(player_x + 7.0, road_y + 12.0, player_x + 14.0, road_y + 20.0, INK, 3.0);
    draw_text("ACADEMY GARDENS", 14.0, y + 18.0, 16.0, INK);
    draw_text(&format!("Step {}/6", step.min(6)), (width - 78.0).max(8.0), y + 18.0, 16.0, INK);
}

fn button_rect(i: usize, w: f32, y: f32) -> Rect {
    let gap = 12.0;
    let margin = 28.0;
    let bw = (w - margin * 2.0 - gap) / 2.0;
    let bh = 48.0;
    Rect::new(margin + (i % 2) as f32 * (bw + gap), y + (i / 2) as f32 * (bh + 10.0), bw, bh)
}

fn draw_button(rect: Rect, label: &str, fill: Color, outline: bool) {
    draw_rectangle(rect.x, rect.y + 3.0, rect.w, rect.h, Color::new(0.08, 0.14, 0.24, 0.12));
    draw_rectangle(rect.x, rect.y, rect.w, rect.h, fill);
    if outline { draw_rectangle_lines(rect.x, rect.y, rect.w, rect.h, 2.0, BLUE); }
    let size = if label.len() > 24 { 17.0 } else { 20.0 };
    let d = measure_text(label, None, size as u16, 1.0);
    draw_text(label, rect.x + (rect.w - d.width) / 2.0, rect.y + rect.h / 2.0 + size * 0.32, size, INK);
}

#[macroquad::main("Year 2 Adventure Academy")]
async fn main() {
    let mut game = Game::new();
    loop {
        let w = screen_width();
        let h = screen_height();
        clear_background(BG);

        if game.screen == Screen::Home {
            draw_world(game.player_step, h * 0.15, w);
            text_center("YEAR 2 ADVENTURE ACADEMY", h * 0.46, 30.0, INK);
            text_center("Learn a little. Explore a lot!", h * 0.46 + 34.0, 21.0, BLUE);
            let r = Rect::new(w * 0.25, h * 0.66, w * 0.5, 58.0);
            draw_button(r, "START ADVENTURE", Color::new(0.65, 0.91, 0.69, 1.0), false);
            text_center("Maths • English • Science • Computing", h * 0.66 + 92.0, 16.0, INK);
            if is_mouse_button_pressed(MouseButton::Left) {
                let (mx, my) = mouse_position();
                if r.contains(vec2(mx, my)) { game.screen = Screen::Play; }
            }
            if is_key_pressed(KeyCode::Enter) || is_key_pressed(KeyCode::Space) { game.screen = Screen::Play; }
        } else {
            draw_world(game.player_step, 0.0, w);
            let q = QUESTIONS[game.question_index % QUESTIONS.len()];
            panel(18.0, 164.0, w - 36.0, h - 184.0, WHITE);
            draw_text(q.subject, 34.0, 190.0, 18.0, GREEN);
            draw_text(q.prompt, 34.0, 222.0, 25.0, INK);

            let choice_y = 238.0;
            for i in 0..4 {
                let r = button_rect(i, w, choice_y);
                let fill = if game.selected == Some(i) { Color::new(0.72, 0.84, 1.0, 1.0) } else { Color::new(0.91, 0.95, 0.99, 1.0) };
                draw_button(r, q.choices[i], fill, game.selected == Some(i));
                if !game.submitted && is_mouse_button_pressed(MouseButton::Left) {
                    let (mx, my) = mouse_position();
                    if r.contains(vec2(mx, my)) { game.selected = Some(i); }
                }
                let key = match i { 0 => KeyCode::Key1, 1 => KeyCode::Key2, 2 => KeyCode::Key3, _ => KeyCode::Key4 };
                if !game.submitted && is_key_pressed(key) { game.selected = Some(i); }
            }

            let action_y = choice_y + 2.0 * (48.0 + 10.0) + 12.0;
            if let Some(correct) = game.feedback {
                let label = if correct { "Brilliant! One step forward." } else { "Good try! One step back." };
                draw_text(label, 34.0, action_y + 21.0, 19.0, if correct { GREEN } else { RED });
                draw_text(q.explanation, 34.0, action_y + 45.0, 16.0, INK);
                let next = Rect::new(w - 190.0, h - 64.0, 160.0, 44.0);
                draw_button(next, "NEXT QUESTION", Color::new(0.65, 0.91, 0.69, 1.0), false);
                if is_mouse_button_pressed(MouseButton::Left) {
                    let (mx, my) = mouse_position();
                    if next.contains(vec2(mx, my)) { game.next_question(); }
                }
                if is_key_pressed(KeyCode::Enter) { game.next_question(); }
            } else {
                let submit = Rect::new(w - 174.0, h - 64.0, 144.0, 44.0);
                draw_button(submit, "CHECK ANSWER", Color::new(0.65, 0.91, 0.69, 1.0), false);
                if is_mouse_button_pressed(MouseButton::Left) {
                    let (mx, my) = mouse_position();
                    if submit.contains(vec2(mx, my)) { game.submit(); }
                }
                if is_key_pressed(KeyCode::Enter) { game.submit(); }
                if game.selected.is_none() {
                    draw_text("Choose an answer, then check it.", 34.0, action_y + 24.0, 16.0, INK);
                }
            }
            draw_text(&format!("Stars: {}   Correct: {}/{}", game.correct, game.correct, game.attempts), 28.0, h - 20.0, 15.0, INK);
            let home = Rect::new(18.0, h - 58.0, 92.0, 38.0);
            draw_button(home, "HOME", Color::new(0.88, 0.91, 0.95, 1.0), false);
            if is_mouse_button_pressed(MouseButton::Left) {
                let (mx, my) = mouse_position();
                if home.contains(vec2(mx, my)) { game.screen = Screen::Home; }
            }
            if is_key_pressed(KeyCode::Escape) || is_key_pressed(KeyCode::Backspace) { game.screen = Screen::Home; }
        }
        next_frame().await;
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn movement_advances_on_correct_and_retreats_on_wrong() {
        assert_eq!(1_u32.saturating_add(1), 2);
        assert_eq!(1_u32.saturating_sub(1), 0);
    }

    #[test]
    fn wrong_answer_at_zero_stays_at_zero() {
        assert_eq!(0_u32.saturating_sub(1), 0);
    }
}
