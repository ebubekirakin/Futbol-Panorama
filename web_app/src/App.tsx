import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import MainLayout from './layouts/MainLayout';
import Home from './pages/Home';
import Login from './pages/auth/Login';
import Signup from './pages/auth/Signup';
import CreateAnalysis from './pages/CreateAnalysis';
import PreMatch from './pages/PreMatch';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        
        <Route path="/" element={<MainLayout />}>
          <Route index element={<Home />} />
          <Route path="create-analysis" element={<CreateAnalysis />} />
          <Route path="pre-match" element={<PreMatch />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;