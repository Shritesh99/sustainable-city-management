import { useState, useEffect } from 'react';
import { userService } from '../services';

export default function Home() {
  const [user, setUsers] = useState(null);

  useEffect(() => {
    setUsers(userService.userValue)
  }, []);
  
  return (
    <div className="card mt-4">
        <div className="card-body">
            {user &&
                <h4>Welcome {user.firstName} {user.lastName}, role: {user.roleId}, userId: {user.userId}, expires: {user.expires}</h4> 
            }
            {!user && <div className="spinner-border spinner-border-sm"></div>}
        </div>
    </div>
);
}
