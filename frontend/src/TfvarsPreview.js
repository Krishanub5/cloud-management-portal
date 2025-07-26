import React, { useState } from 'react';
import axios from 'axios';

function TfvarsPreview({ config }) {
  const [tfvars, setTfvars] = useState("");
  const [loading, setLoading] = useState(false);

  const generateTfvars = async () => {
    setLoading(true);
    const response = await axios.post("http://localhost:8000/generate-tfvars", config);
    setTfvars(response.data.result);
    setLoading(false);
  };

  return (
    <div>
      <h3>AI-Generated .tfvars Preview</h3>
      <button onClick={generateTfvars} disabled={loading}>
        {loading ? "Generating..." : "Generate Preview"}
      </button>
      <pre style={{ background: "#f4f4f4", padding: "10px", marginTop: "10px" }}>
        {tfvars}
      </pre>
    </div>
  );
}

export default TfvarsPreview;
