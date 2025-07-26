import React, { useEffect, useState } from 'react';

function Navbar() {
  const [darkMode, setDarkMode] = useState(false);

  useEffect(() => {
    document.documentElement.classList.toggle("dark", darkMode);
  }, [darkMode]);

  return (
    <nav className="bg-blue-700 p-4 text-white shadow-md flex justify-between items-center">
      <h2 className="text-xl font-bold">Azure Cloud Management Portal</h2>
      <button onClick={() => setDarkMode(!darkMode)} className="bg-white text-blue-700 px-3 py-1 rounded text-sm">
        {darkMode ? "Light" : "Dark"}
      </button>
    </nav>
  );
}

export default Navbar;
