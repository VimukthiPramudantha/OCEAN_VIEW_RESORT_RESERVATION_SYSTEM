package com.hotel.dao;

import java.util.List;

// Abstraction (Generic Interface)
public interface BaseDAO<T, ID> {
    T findById(ID id);
    List<T> findAll();
    boolean save(T entity);

}
