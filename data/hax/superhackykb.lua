print("Loading hacky KB?")

dofile_once("data/hax/utf8.lua")

if _hacky_keyboard_defined then
  return
end

_hacky_keyboard_defined = true

hack_type = function()
  return ""
end

hack_discard_text_input = function()
end

if not require then
  print("No require? Urgh.")
  return
end

local ffi = require('ffi')
if not ffi then
  print("No FFI? Well that's a pain.")
  return
end

_keyboard_present = true

ffi.cdef([[
  const uint8_t* SDL_GetKeyboardState(int* numkeys);
  uint32_t SDL_GetKeyFromScancode(uint32_t scancode);
  char* SDL_GetScancodeName(uint32_t scancode);
  char* SDL_GetKeyName(uint32_t key);
  typedef struct SDL_TextInputEvent {
    uint32_t type;
    uint32_t timestamp;
    uint32_t windowID;
    char text[32];
  } SDL_TextInputEvent;
  typedef union SDL_Event {
    uint32_t type;
    SDL_TextInputEvent text;
    uint8_t padding[56];
  } SDL_Event;
  typedef int (*SDL_EventFilter)(void* userdata, SDL_Event* event);
  void SDL_AddEventWatch(SDL_EventFilter filter, void* userdata);
  void SDL_StartTextInput(void);
]])
_SDL = ffi.load('SDL2.dll')

local SDL_TEXTINPUT = 0x303
local pending_text_input = {}

_keyboard_event_watch = ffi.cast("SDL_EventFilter", function(_, event)
  if event[0].type == SDL_TEXTINPUT then
    local text = ffi.string(event[0].text.text)
    if text ~= "" then
      pending_text_input[#pending_text_input + 1] = text
    end
  end
  return 1
end)

_SDL.SDL_AddEventWatch(_keyboard_event_watch, nil)
_SDL.SDL_StartTextInput()

local function take_text_input()
  local text = table.concat(pending_text_input)
  pending_text_input = {}
  return text
end

hack_discard_text_input = function()
  pending_text_input = {}
end

local code_to_a = {}
local shifts = {}

for i = 0, 284 do
  local keycode = _SDL.SDL_GetKeyFromScancode(i)
  if keycode > 0 then
    local keyname = ffi.string(_SDL.SDL_GetKeyName(keycode))
    if keyname and #keyname > 0 then
      code_to_a[i] = utf8_lower(keyname)
      if keyname:lower():find("shift") then
        table.insert(shifts, i)
      end
    end
  end
end

local prev_state = {}
for i = 0, 284 do
  prev_state[i] = 0
end

function hack_update_keys()
  local keys = _SDL.SDL_GetKeyboardState(nil)
  local pressed = {}
  -- start at scancode 1 because we don't care about "UNKNOWN"
  for scancode = 1, 284 do 
    if keys[scancode] > 0 and prev_state[scancode] <= 0 then
      pressed[#pressed+1] = code_to_a[scancode]
    end
    prev_state[scancode] = keys[scancode]
  end
  local shift_held = false
  for _, shiftcode in ipairs(shifts) do
    if keys[shiftcode] > 0 then
      shift_held = true
      break
    end
  end
  return pressed, shift_held
end

local REPLACEMENTS = {
  space = " "
}

hack_type = function(current_str, no_shift)
  local pressed, shift_held = hack_update_keys()
  local text_input = take_text_input()
  local received_text_input = text_input ~= ""
  local hit_enter = false

  if received_text_input and (no_shift or shift_held) then
    current_str = current_str .. text_input
  end

  for _, key in ipairs(pressed) do
    if key == "backspace" then
      current_str = utf8_remove_last_character(current_str)
    elseif key == "enter" or key == "return" then
      hit_enter = true
    elseif not received_text_input
        and (no_shift or shift_held)
        and REPLACEMENTS[key] then
      current_str = current_str .. REPLACEMENTS[key]
    elseif not received_text_input
        and (no_shift or shift_held)
        and utf8_is_single_character(key) then
      current_str = current_str .. key
    end
  end
  return current_str, hit_enter
end

print("Hacky KB loaded?")