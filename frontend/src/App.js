import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Sidebar from './components/Sidebar';
import Footer from './components/Footer';
import VendingRequest from './pages/VendingRequest';
import UploadInfraTemplate from './UploadInfraTemplate';
import AssistantChat from './AssistantChat';
import DeploymentHistory from './pages/DeploymentHistory';
import './index.css';

function App() {
  const [page, setPage] = useState("Vending Request");

  const renderPage = () => {
    switch (page) {
      case "Upload Template": return <UploadInfraTemplate />;
      case "AI Assistant": return <AssistantChat />;
      case "Deployment History": return <DeploymentHistory />;
      default: return <VendingRequest />;
    }
  };

  return (
    <div className="flex flex-col h-screen">
      <Navbar />
      <div className="flex flex-1 overflow-hidden">
        <Sidebar onNavigate={setPage} />
        <main className="flex-1 overflow-auto p-6 bg-gray-50">
          {renderPage()}
        </main>
      </div>
      <Footer />
    </div>
  );
}

export default App;
