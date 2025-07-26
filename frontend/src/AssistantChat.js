import React, { useState } from 'react';
import axios from 'axios';

function AssistantChat() {
  const [query, setQuery] = useState("");
  const [reply, setReply] = useState("");

  const ask = async () => {
    const response = await axios.post("http://localhost:8000/ask-assistant", { question: query });
    setReply(response.data.answer);
  };

  return (
    <div>
      <h4>AI Infra Assistant</h4>
      <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Ask something..." />
      <button onClick={ask}>Ask</button>
      <pre>{reply}</pre>
    </div>
  );
}

export default AssistantChat;
