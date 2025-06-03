module Time : sig
    val error : float

    val equal : float -> float -> bool
    val less : float -> float -> bool
    val less_equal : float -> float -> bool
    val greater : float -> float -> bool
    val greater_equal : float -> float -> bool
end
