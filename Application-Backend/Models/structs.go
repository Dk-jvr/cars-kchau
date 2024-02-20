package Models

type (
	User struct {
		Email    string `json:"email"`
		Username string `json:"username"`
		Password string `json:"password"`
	}
	AuthUser struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
)
