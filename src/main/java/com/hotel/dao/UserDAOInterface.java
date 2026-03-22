package com.hotel.dao;

import com.hotel.model.User;

//Abstraction
public interface UserDAOInterface extends BaseDAO<User, String> {
    User findByUsernameAndPassword(String username, String password);
    boolean isUsernameExists(String username);
}
