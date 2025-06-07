using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace dotnet.Services
{
    public class AIAssistantService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public AIAssistantService(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            _config = config;
        }

        public async Task<string> GetAIReplyAsync(List<(string Role, string Content)> messages)
        {
            var apiKey = _config["OpenAI:ApiKey"];
            var apiUrl = "https://api.openai.com/v1/chat/completions";

            var requestBody = new
            {
                model = "gpt-3.5-turbo",
                messages = messages.Select(m => new { role = m.Role, content = m.Content }).ToArray(),
                temperature = 0.7
            };

            var requestContent = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

            var response = await _httpClient.PostAsync(apiUrl, requestContent);
            var responseString = await response.Content.ReadAsStringAsync();

            using var doc = JsonDocument.Parse(responseString);
            var root = doc.RootElement;

            if (root.TryGetProperty("error", out JsonElement error))
            {
                var errorMsg = error.GetProperty("message").GetString();
                return $"⚠️ OpenAI Error: {errorMsg}";
            }

            if (root.TryGetProperty("choices", out var choices) &&
                choices.GetArrayLength() > 0 &&
                choices[0].TryGetProperty("message", out var message) &&
                message.TryGetProperty("content", out var content))
            {
                return content.GetString() ?? "🤖 Assistant gave an empty reply.";
            }

            return "❌ Unexpected response format from AI.";
        }

        public string GetSystemPrompt()
        {
            return @"
            You are FitBot, the smart and friendly AI assistant inside the FitTrack fitness app. 
            Your job is to help users understand and use the app better.

            FitTrack allows users to:
            - Set fitness goals on first login (e.g. lose weight, gain muscle, boost endurance).
            - Add their age, gender, height, weight to get personalized advice.
            - Save meals with ingredients, macros, and an image.
            - Track calories eaten and burned.
            - Schedule workouts (running, gym, hiking, etc.).
            - Get notified 5 minutes before a workout starts.
            - Track workout progress, pause/resume, and monitor streaks.

            Be helpful, clear, and supportive. Stick to the app's features when answering.
            ";
        }
        
        public async Task<string> GenerateConversationTitleAsync(List<(string Role, string Content)> messages)
        {
            var prompt = @"
                You are a title generator bot. 
                Summarize the following chat into a short, meaningful title (max 8 words).
                Do NOT include FitTrack App at start, quotation marks, speaker names, or emojis.
                Just a simple summary in a few words.

                Chat:
            ";

            var chatHistory = string.Join("\n", messages.Select(m => $"{m.Role}: {m.Content}"));
            var fullPrompt = prompt + "\n" + chatHistory;

            var apiKey = _config["OpenAI:ApiKey"];
            var apiUrl = "https://api.openai.com/v1/chat/completions";

            var requestBody = new
            {
                model = "gpt-3.5-turbo",
                messages = new[]
                {
                    new { role = "system", content = "You generate concise conversation titles based on chat." },
                    new { role = "user", content = fullPrompt }
                },
                temperature = 0.5
            };

            var requestContent = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

            var response = await _httpClient.PostAsync(apiUrl, requestContent);
            var responseString = await response.Content.ReadAsStringAsync();

            using var doc = JsonDocument.Parse(responseString);
            var root = doc.RootElement;

            if (root.TryGetProperty("choices", out var choices) &&
                choices.GetArrayLength() > 0 &&
                choices[0].TryGetProperty("message", out var message) &&
                message.TryGetProperty("content", out var content))
            {
                var rawTitle = content.GetString()?.Trim() ?? "New Conversation";
                return rawTitle.Trim('"');
            }

            return "New Conversation";
        }
    }
}