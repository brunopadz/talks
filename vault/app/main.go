package main

import (
	"github.com/gofiber/fiber/v2"
	"os"
)

func main() {
	app := fiber.New()

	o := "Hello " + os.Getenv("NAME")

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString(o)
	})

	app.Listen(":3000")
}
