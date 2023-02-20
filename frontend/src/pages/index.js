import { useState, useEffect } from 'react';
import { userService } from '../services';

export default function Home() {
  // const [users, setUsers] = useState(null);
  // useEffect(() => {
  //     userService.getAll().then(x => setUsers(x));
  // }, []);
  // return <div className="container">woking</div>;
  
//   return (
//     <div className="card mt-4">
//         <h4 className="card-header">You're logged in successfully!!</h4>
//         <div className="card-body">
//             <h6>Users from secure api end point</h6>
//             {users &&
//                 <ul>
//                     {users.map(user =>
//                         <li key={user.userId}>{user.firstName} {user.lastName} {user.roleId}</li>
//                     )}
//                 </ul>
//             }
//             {!users && <div className="spinner-border spinner-border-sm"></div>}
//         </div>
//     </div>
// );

  return <div className="container">woking</div>;
}
