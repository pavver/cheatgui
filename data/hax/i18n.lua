local locale_aliases = {
  en = "en",
  English = "en",
  br = "pt-br",
  cn = "zh-cn",
  de = "de",
  Deutsch = "de",
  es = "es-es",
  ["es-es"] = "es-es",
  ["Español"] = "es-es",
  fr = "fr-fr",
  ["fr-fr"] = "fr-fr",
  ["Français"] = "fr-fr",
  it = "it",
  Italiano = "it",
  ja = "jp",
  jp = "jp",
  ["日本語"] = "jp",
  ko = "ko",
  ["한국어"] = "ko",
  pl = "pl",
  Polska = "pl",
  pt = "pt-br",
  ["pt-br"] = "pt-br",
  ["Português (Brasil)"] = "pt-br",
  ru = "ru",
  ["русский"] = "ru",
  ua = "uk",
  uk = "uk",
  ["Українська"] = "uk",
  ["українська"] = "uk",
  zh = "zh-cn",
  ["zh-cn"] = "zh-cn",
  ["简体中文"] = "zh-cn"
}

local fallback_locale = "en"
local detected_locale = GameTextGet("$current_language")
local current_locale = locale_aliases[detected_locale] or fallback_locale
local locale_path = "data/hax/i18n/"

local fallback_strings = dofile(locale_path .. fallback_locale .. ".lua")
local current_strings = fallback_strings

if current_locale ~= fallback_locale then
  current_strings = dofile(locale_path .. current_locale .. ".lua")
end

local function interpolate(text, values)
  if values == nil then return text end
  return (text:gsub("{([%w_]+)}", function(name)
    local value = values[name]
    if value == nil then return "{" .. name .. "}" end
    return tostring(value)
  end))
end

function tr(key, values)
  local text = current_strings[key] or fallback_strings[key]
  if text == nil then return "[[" .. key .. "]]" end
  return interpolate(text, values)
end

function get_cheatgui_locale()
  return current_locale
end
