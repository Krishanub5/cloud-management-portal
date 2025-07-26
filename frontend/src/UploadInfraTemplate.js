import React, { useState } from 'react';
import axios from 'axios';

function UploadInfraTemplate() {
  const [file, setFile] = useState(null);
  const [output, setOutput] = useState("");

  const handleUpload = async () => {
    const form = new FormData();
    form.append("file", file);
    const res = await axios.post("http://localhost:8000/upload-infra-template/", form);
    setOutput(JSON.stringify(res.data, null, 2));
  };

  return (
    <div>
      <h4>📄 Upload Infra Template</h4>
      <input type="file" onChange={(e) => setFile(e.target.files[0])} />
      <button onClick={handleUpload}>Upload & Analyze</button>
      <pre>{output}</pre>
    </div>
  );
}

export default UploadInfraTemplate;
