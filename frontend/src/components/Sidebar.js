import React from 'react';

function Sidebar({ onNavigate }) {
  const links = ["Vending Request", "Upload Template", "AI Assistant", "Deployment History"];
  return (
    <aside className="w-60 bg-gray-100 p-4 shadow-md h-screen">
      <ul className="space-y-3">
        {links.map(link => (
          <li key={link}>
            <button onClick={() => onNavigate(link)} className="w-full bg-white hover:bg-blue-100 text-left p-2 rounded">
              {link}
            </button>
          </li>
        ))}
      </ul>
    </aside>
  );
}

export default Sidebar;
